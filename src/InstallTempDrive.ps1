using namespace System.Security.Principal

param(
    [IO.DirectoryInfo] $tempFolder = ([IO.DirectoryInfo]"c:\Temp\TempDrive"),
    [char] $driveLetter = 'T',
    [TimeSpan] $retentionPeriod = [TimeSpan]::FromDays(14),
    [switch] $elevatedForTaskScheduler
)

$isElevated = ([WindowsPrincipal][WindowsIdentity]::GetCurrent()).IsInRole([WindowsBuiltInRole]::Administrator)

if ($isElevated -and !$elevatedForTaskScheduler) {
    Write-Host "Please start script non elevated" -ForegroundColor Red
    Exit
}

if (!$elevatedForTaskScheduler) 
{
    if (!(Test-Path $tempFolder))
    {
        New-Item -ItemType Directory -Path $tempFolder -Force > $null
    }

    if (!(Test-Path "$($driveLetter):")) 
    {
        $uncTempFolderPath = Join-Path \\localhost ($tempFolder -replace ':', '$').TrimEnd('\')  

        New-PSDrive -Name $driveLetter -PSProvider FileSystem -Root $uncTempFolderPath -Persist -Scope Global > $null

        $createDrivecmd = "New-PSDrive -Name $($driveLetter) -PSProvider FileSystem -Root $($uncTempFolderPath) -Persist -Scope Global -ea SilentlyContinue"

        New-Item -ItemType File -Force `
            -Path ("{0}\CreateTempDrive_$($driveLetter).bat" -f [Environment]::GetFolderPath("startup")) `
            -Value "powershell.exe -NoProfile -WindowStyle Hidden -Command `"$($createDrivecmd)`"" > $null
    }

    $proc = [Diagnostics.ProcessStartInfo]::new("powershell.exe")
    $proc.Verb = "runas"
    $proc.Arguments = " -NoProfile -WindowStyle Hidden $($MyInvocation.MyCommand.Definition) $tempFolder $driveLetter $retentionPeriod -elevatedForTaskScheduler" 
    $executedElevatedProcess = [Diagnostics.Process]::Start($proc)
}

$taskName = "TempDrive_$($driveLetter)_ClearFilesExceedingRetentionPeriod"

if ($elevatedForTaskScheduler) 
{
    $scheduledTaskArgs = @{
        TaskName = $taskName;
        Description = "Remove files in TempDrive older than a certain period";
        Action = (New-ScheduledTaskAction -Execute powershell.exe `
            -Argument " -NoProfile -WindowStyle Hidden -File $(Join-Path $PSScriptRoot PurgeOldFiles.ps1) -path $tempFolder -retentionPeriod $retentionPeriod");
        Trigger = (New-ScheduledTaskTrigger -Daily -At 11am);
    }

    if (Get-ScheduledTask $taskName -ea SilentlyContinue) {

        Unregister-ScheduledTask $taskName -Confirm:$False
    }

    Register-ScheduledTask @scheduledTaskArgs > $null

    Exit
}

if (!$isElevated -and $executedElevatedProcess) {

    $task = Get-ScheduledTask $taskName -ea SilentlyContinue
    
    Write-Host "`nCreated temporary drive '$($driveLetter):' Linked to '$tempFolder'`n`nCreated Scheduled Task: '$($task.TaskName)'`n"
    
    Write-Host "Daily at $(([DateTime]$task.Triggers.StartBoundary).ToString("HH:mm:ss")) remove files older than $($retentionPeriod.TotalDays) days`n"
}