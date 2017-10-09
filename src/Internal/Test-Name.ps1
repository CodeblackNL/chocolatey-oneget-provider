
function Test-Name {
    [CmdletBinding()]
    [OutputType([bool])]
    param (
        [string]
        $Name,
        
        [string]
        $PackageName,
        
        [bool]
        $NameContainsWildcard
    )

    $nameRegex = "^.*$($Name.TrimStart('*').TrimEnd('.')).*$"

    if ($Name -and $PackageName -and ($PackageName -notmatch "$nameRegex")) {
        return $false
    }

    if ($Name -and $PackageName -and (-not $NameContainsWildcard) -and ($Name -ne $PackageName)) {
        return $false
    }

    return $true
}