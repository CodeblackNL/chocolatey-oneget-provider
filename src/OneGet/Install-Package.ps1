
function Install-Package { 
    [CmdletBinding()]
    param (
        [Parameter(Mandatory = $true)]
        [ValidateNotNullOrEmpty()]
        [string]
        $FastPackageReference
    )

    Write-Debug -Message ($LocalizedData.ProviderDebugMessage -f ('Install-Package'))  
    Write-Debug -Message ($LocalizedData.FastPackageReference -f $fastPackageReference)

    $progress = 5
    Write-Progress -Activity $LocalizedData.InstallingPackage -PercentComplete $progress -Id $script:InstallPackageProgressId 

    $force = Get-ForceOption

    if (-not ($FastPackageReference -match $script:fastReferenceRegex)) {
        Write-Error ($LocalizedData.InstallFailedInvalidFastReference -f $FastPackageReference)  
        return
    }

    $packageSource = $Matches.source
    $packageName = $Matches.name
    $packageVersion = $Matches.version

    if (-not ($packageSource -and $packageName -and $packageVersion)) {
        Write-Error ($LocalizedData.InstallFailedInvalidFastReference -f $FastPackageReference)  
        return
    }

    #$shouldContinueCaption = $LocalizedData.ShouldContinueCaption
    #$shouldContinueQueryMessage = ($LocalizedData.InstallPackageQuery -f $packageName)
    #if (-not ($force -or $request.ShouldContinue($shouldContinueQueryMessage, $shouldContinueCaption))) {
    #    Write-Warning ($LocalizedData.InstallCancelled -f $packageName)  
    #    return       
    #}

    $arguments = @(
        $packageName
        '--version'
        $packageVersion
        "--source='$packageSource'"
        '--yes'
        '--prerelease'
    )

    if ($force) {
        $arguments += '--force'
    }

    #if (Get-PrereleaseOption) {
    #    $arguments += '--prerelease'
    #}

    if (Get-ForceDependenciesOption) {
        $arguments += '--force-dependencies'
    }
    elseif (Get-IgnoreDependenciesOption) {
        $arguments += '--ignore-dependencies'
    }

    if (Get-SkipPowershellOption) {
        $arguments += '--skip-powershell'
    }

    $cacheLocation = Get-CacheLocationOption
    if ($cacheLocation) {
        $arguments += '--cache-location'
        $arguments += "'$cacheLocation'"
    }

    $packageParameters = Get-PackageParametersOption
    if ($packageParameters) {
        $arguments += '--package-parameters'
        $arguments += """$($packageParameters.Replace('"', '""'))"""
    }

    $progress = 20
    Write-Progress -Activity $LocalizedData.InstallingPackage -PercentComplete $progress -Id $script:InstallPackageProgressId

    $chocoInstall = Invoke-Chocolatey -Command 'upgrade' -Arguments $arguments -Force $force

    $progress = 80
    Write-Progress -Activity $LocalizedData.InstallingPackage -PercentComplete $progress -Id $script:InstallPackageProgressId

    $success = $false
    $alreadyInstalled = $false
    $chocoInstall | ForEach-Object {
        if ($_ -match $script:packageReportRegex) {
            [int]$done = $Matches.done
            [int]$total = $Matches.total
            if ($done -ge 1 -and $done -eq $total) {
                $success = $true
            }
        }
        elseif ($_ -match 'already installed') {
            $alreadyInstalled = $true
        }
    }

    if ($alreadyInstalled) {
        Write-Error ($LocalizedData.AlreadyInstalled -f $packageName, $packageVersion)
        return
    }
    elseif (-not $success) {
        Write-Error ($LocalizedData.InstallFailed -f $packageName)  
        return
    }
    else {
        $swidObject = @{
            FastPackageReference = [string]::Join('#', @($packageSource, $packageName, $packageVersion))
            Name = $packageName
            Version = $packageVersion
            versionScheme  = 'MultiPartNumeric'
            #Summary = $packageSummary
            Source = $packageSource
            FromTrustedSource = $true
        }

        $swid = New-SoftwareIdentity @swidObject              
        Write-Output -InputObject $swid
    }

    Write-Progress -Activity $LocalizedData.Complete -PercentComplete 100 -Completed -Id $script:InstallPackageProgressId               
}
