#Requires -Version 5.0

Microsoft.PowerShell.Utility\Import-LocalizedData  LocalizedData -FileName 'ChocoOneGet.Resource.psd1'

$script:providerName = "Choco"

$script:allVersions         = 'AllVersions'
$script:force               = 'Force'
$script:prerelease          = 'Prerelease'
$script:packageParameters   = 'PackageParameters'
$script:ignoreDependencies  = 'IgnoreDependencies'
$script:forceDependencies   = 'ForceDependencies'
$script:skipPowershell      = 'SkipPowershell'
$script:cacheLocation       = 'CacheLocation'
$script:switches            = 'Switches'

$script:FindPackageProgressId = 10
$script:InstallPackageProgressId = 11
$script:UnInstallPackageProgressId = 12
$script:InstalledPackageProgressId = 15
#$script:InstallChocolateyProgressId = 16

$script:sourceRegex = '(?<name>[\S]*) - (?<location>[^|]*) |'
$script:packageRegex = '^(?<name>[\S]*)\s+(?<version>\d\S*)(\s*(?<summary>.*))?'
$script:packageReportRegex = 'Chocolatey (un)?installed (?<done>\d+)/(?<total>\d+) packages'
$script:fastReferenceRegex = '(?<source>[^#].*)#(?<name>[^#]*)#(?<version>.*)'

Get-ChildItem -Path "$PSScriptRoot\Internal" -Filter '*.ps1' -Recurse | ForEach-Object {
    . $_.FullName
#    Export-ModuleMember -Function ([System.IO.Path]::GetFileNameWithoutExtension($_.Name))
}

Get-ChildItem -Path "$PSScriptRoot\OneGet" -Filter '*.ps1' -Recurse | ForEach-Object {
    . $_.FullName
}
