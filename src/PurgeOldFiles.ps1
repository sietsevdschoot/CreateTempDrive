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

$oldFiles = dir $path.FullName -Recurse -File | ?{ $_.CreationTime -lt $now.Subtract($retentionPeriod) }

$folders = dir $path.FullName -Recurse -Directory | Sort -Property @{ Expression={ $_.FullName.Length }; Descending=$true } 
$emptyFolders = $folders | ?{ (dir $_.FullName -file -Recurse | ?{ $_.CreationTime -gt $now.Subtract($retentionPeriod) }) -eq $null } 

$oldFiles | del -Force
$emptyFolders | %{ del $_.FullName -Force }