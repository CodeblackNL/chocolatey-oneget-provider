
function Get-RequestOption {
    param (
        [Parameter(Mandatory = $true)]
        [string]$Name
    )

    if ($Name -in @(
            $script:allVersions
            $script:force
            $script:prerelease
            $script:ignoreDependencies
            $script:forceDependencies
            $script:skipPowershell
    )) {
        # Switch-option
        $options = $request.Options
        if ($options) {
            if ($options.ContainsKey($Name)) {
                return $options[$Name] -eq 'True'
            }
            elseif ($options.ContainsKey($script:switches)) {
                $switches = @($options[$script:switches] -split '\W')
                return ($switches -contains $Name) -or ($switches -contains "-$Name")
            }
        }

        return $false
    }
    else {
        # String-option
        $options = $request.Options
        if ($options -and $options.ContainsKey($Name)) {	
		    return $options[$Name]
        }

        return $null
    }
}

function Get-AllVersionsOption {
    return Get-RequestOption -Name $script:allVersions
}

function Get-ForceOption {
    return Get-RequestOption -Name $script:force
}

function Get-PrereleaseOption {
    return Get-RequestOption -Name $script:prerelease
}

function Get-IgnoreDependenciesOption {
    return Get-RequestOption -Name $script:ignoreDependencies
}

function Get-ForceDependenciesOption {
    return Get-RequestOption -Name $script:forceDependencies
}

function Get-SkipPowershellOption {
    return Get-RequestOption -Name $script:skipPowershell
}

function Get-PackageParametersOption {
    return Get-RequestOption -Name $script:packageParameters
}

function Get-CacheLocationOption {
    return Get-RequestOption -Name $script:cacheLocation
}
