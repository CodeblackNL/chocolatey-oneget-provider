
function Process-Package {
    [CmdletBinding()]
    param (
        [string[]]
        $Packages,

        [string]
        $Name,

        [bool]
        $NameContainsWildCard = $false,

        [string]
        $Source,

        [string]
        $RequiredVersion,

        [string]
        $MinimumVersion,

        [string]
        $MaximumVersion,

        [string]
        $OperationMessage,

        [int]
        $ProgressStart = 0,

        [int]
        $ProgressEnd = 100,

        [int]
        $ProgressId
    )
  
    if ($packages) {
        $progressStep = ($ProgressEnd - $ProgressStart) / $packages.Length

        $index = 0
        foreach ($package in $packages) {
            if ($request.IsCanceled) {
                return
            } 
        
            $index++
            [int]$progress = $ProgressStart + ($index * $progressStep)
            $progress = [System.Math]::Min(100, $progress)
            Write-Progress -Activity $LocalizedData.ProcessingPackage -PercentComplete $progress -Id $ProgressId 
            #if (($package -match $script:packageRegex) -and ($package -notmatch $script:packageReportRegex)) {
            if ($package -match $script:packageRegex) {
                $packageName = $Matches.name
                $packageVersion = $Matches.version
                $packageSummary = $Matches.summary

                Write-Debug ("Choco message: '{0}'" -f $package)

                if ($packageName -and $packageVersion) {
                    if (-not (Test-Name -Name $Name -PackageName $packageName -NameContainsWildcard $NameContainsWildCard)) {
                        Write-Debug ("Skipping processing: '{0}'" -f $packageName)
                        continue
                    }

                    if ((Test-Version -Version $packageVersion `
                                      -RequiredVersion $requiredVersion `
                                      -MinimumVersion $minimumVersion `
                                      -MaximumVersion $maximumVersion )) {                                  
                        $swidObject = @{
                            FastPackageReference = [string]::Join('#', @($Source, $packageName, $packageVersion))
                            Name = $packageName
                            Version = $packageVersion
                            versionScheme  = 'MultiPartNumeric'
                            Summary = $packageSummary
                            Source = $Source
                            FromTrustedSource = $true
                        }

                        $swid = New-SoftwareIdentity @swidObject              
                        Write-Output -InputObject $swid
                    } 
                }
            }
        }
    }
}
