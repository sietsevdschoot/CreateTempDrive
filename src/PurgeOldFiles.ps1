[CmdletBinding(SupportsShouldProcess)]
param (
    [Parameter(Mandatory)]
    [IO.DirectoryInfo] $path,
    [TimeSpan] $retentionPeriod = [TimeSpan]::FromDays(14),
    [DateTime] $now = [DateTime]::MinValue
)

if ($now -eq [DateTime]::MinValue) {

    $now = (Get-Date)
}

$oldFiles = Get-ChildItem $path.FullName -Recurse -File | Where-Object { $_.CreationTime -lt $now.Subtract($retentionPeriod) }
$oldFiles | Remove-Item -Force

$folders = Get-ChildItem $path.FullName -Recurse -Directory 
$emptyFolders = $folders | Where-Object { (Get-ChildItem $_.FullName -file -Recurse | Where-Object { $_.CreationTime -gt $now.Subtract($retentionPeriod) }) -eq $null } 

$emptyFolders | Sort-Object -Property @{ Expression={ $_.FullName.Split([IO.Path]::DirectorySeparatorChar).Count }; Descending=$true } | Remove-Item -Force -Recurse