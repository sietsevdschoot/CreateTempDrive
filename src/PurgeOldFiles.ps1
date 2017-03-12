[CmdletBinding(SupportsShouldProcess)]
param (
    [Parameter(Mandatory)]
    [IO.DirectoryInfo] $path,
    [TimeSpan] $retentionPeriod = [TimeSpan]::FromDays(14)
)

$oldFiles = dir $path.FullName -Recurse -File | ?{ $_.CreationTime -lt (Get-Date).Subtract($retentionPeriod) }

$folders = dir $path.FullName -Recurse -Directory | Sort -Property @{ Expression={ $_.FullName.Length }; Descending=$true } 
$emptyFolders = $folders | ?{ (dir $_.FullName -file -Recurse | ?{ $_.CreationTime -gt (Get-Date).Subtract($retentionPeriod) }) -eq $null } 

$oldFiles | rm -Force
$emptyFolders | %{ rm $_.FullName -Force }