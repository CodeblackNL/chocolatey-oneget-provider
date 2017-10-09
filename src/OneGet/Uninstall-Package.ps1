
function Uninstall-Package { 
    [CmdletBinding()]
    param (
        [Parameter(Mandatory = $true)]
        [ValidateNotNullOrEmpty()]
        [string]
        $FastPackageReference
    )

    Write-Debug -Message ($LocalizedData.ProviderDebugMessage -f ('Uninstall-Package'))
    Write-Debug -Message ($LocalizedData.FastPackageReference -f $FastPackageReference)
      
    $progress = 5
    Write-Progress -Activity $LocalizedData.UninstallingPackage -PercentComplete $progress -Id $script:UnInstallPackageProgressId

    $force = Get-ForceOption

    if (-not ($FastPackageReference -match $script:fastReferenceRegex)) {
        Write-Error ($LocalizedData.UninstallFailedInvalidFastReference -f $FastPackageReference)  
        return
    }

    $packageSource = $Matches.source
    $packageName = $Matches.name
    $packageVersion = $Matches.version

    if (-not ($packageSource -and $packageName -and $packageVersion)) {
        Write-Error ($LocalizedData.UninstallFailedInvalidFastReference -f $FastPackageReference)  
        return
    }

    #$shouldContinueCaption = $LocalizedData.ShouldContinueCaption
    #$shouldContinueQueryMessage = ($LocalizedData.UninstallPackageQuery -f $packageName)
    #if (-not ($force -or $request.ShouldContinue($shouldContinueQueryMessage, $shouldContinueCaption))) {
    #    Write-Warning ($LocalizedData.UninstallCancelled -f $packageName)  
    #    return       
    #}

    $arguments = @(
        $packageName
        '--yes'
    )
    if (Get-AllVersionsOption) {
        $arguments += '--allversions'
    }
    else {
        $arguments += '--version'
        $arguments += $packageVersion
    }

    if ($force) {
        $arguments += '--force'
    }

    if (Get-ForceDependenciesOption) {
        $arguments += '--force-dependencies'
    }
    elseif (Get-IgnoreDependenciesOption) {
        $arguments += '--ignore-dependencies'
    }

    if (Get-SkipPowershellOption) {
        $arguments += '--skip-powershell'
    }

    $packageParameters = Get-PackageParametersOption
    if ($packageParameters) {
        $arguments += '--package-parameters'
        $arguments += """$($packageParameters.Replace('"', '""'))"""
    }

    $progress = 20
    Write-Progress -Activity $LocalizedData.UninstallingPackage -PercentComplete $progress -Id $script:UnInstallPackageProgressId

    $chocoInstall = Invoke-Chocolatey -Command 'uninstall' -Arguments $arguments -Force $force

    $progress = 80
    Write-Progress -Activity $LocalizedData.UninstallingPackage -PercentComplete $progress -Id $script:UnInstallPackageProgressId

    $success = $false
    $notInstalled = $false
    $chocoInstall | ForEach-Object {
        if ($_ -match $script:packageReportRegex) {
            [int]$done = $Matches.done
            [int]$total = $Matches.total
            if ($done -ge 1 -and $done -eq $total) {
                $success = $true
            }
        }
        elseif ($_ -match 'not installed') {
            $notInstalled = $true
        }
    }

    if ($notInstalled) {
        Write-Error ($LocalizedData.NotInstalled -f $packageName, $packageVersion)
        return
    }
    elseif (-not $success) {
        Write-Error ($LocalizedData.UninstallFailed -f $packageName)  
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
