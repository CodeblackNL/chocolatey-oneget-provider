
function Get-InstalledPackage { 
    [CmdletBinding()]
    param (
        [Parameter()]
        [string]
        $Name,

        [Parameter()]
        [string]
        $RequiredVersion,

        [Parameter()]
        [string]
        $MinimumVersion,

        [Parameter()]
        [string]
        $MaximumVersion
    )

    Write-Debug ($LocalizedData.ProviderDebugMessage -f ' Get-InstalledPackage')

    $validVersions = Validate-VersionParameters  -Name $Name `
                                                 -MinimumVersion $MinimumVersion `
                                                 -MaximumVersion $MaximumVersion `
                                                 -RequiredVersion $RequiredVersion `
                                                 -AllVersions:(Get-AllVersionsOption)
    if (-not $validVersions) {
        return
    } 

    $nameContainsWildCard = [System.Management.Automation.WildcardPattern]::ContainsWildcardCharacters($Name)

    $progress = 5
    Write-Progress -Activity $LocalizedData.FindingLocalPackage -PercentComplete $progress -Id $script:InstalledPackageProgressId 

    # choco does not support wildcards when searching local-only, so if a user does not provide a name, or a name containing wildcard, search all
    $arguments = @(
        if ($Name -and -not $nameContainsWildCard) { $Name }
        '--local-only'
        '--allversions'
    )
    if (Get-PrereleaseOption) {
        $arguments += '--prerelease'
    }
    $chocoPackages = Invoke-Chocolatey -Command 'list' -Arguments $arguments -Force (Get-ForceOption)

    $progress = 70
    Write-Progress -Activity $LocalizedData.FindingLocalPackage -PercentComplete $progress -Id $script:InstalledPackageProgressId 

    Process-Package -Packages $chocoPackages `
                    -Name $Name -NameContainsWildCard $nameContainsWildCard `
                    -Source $env:COMPUTERNAME `
                    -RequiredVersion $RequiredVersion `
                    -MinimumVersion $MinimumVersion `
                    -MaximumVersion $MaximumVersion `
                    -ProgressStart $progress -ProgressEnd 100 -ProgressId $script:InstalledPackageProgressId
    
    Write-Progress -Activity $LocalizedData.Complete -PercentComplete 100 -Completed -Id $script:InstalledPackageProgressId    
}
