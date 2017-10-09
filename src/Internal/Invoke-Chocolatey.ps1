
function Invoke-Chocolatey {
    [CmdletBinding()]
    param (
        [string]
        $Command,

        [string[]]
        $Arguments,

        [bool]
        $Force
    )

    Write-Debug ($LocalizedData.ProviderDebugMessage -f 'Invoke-Chocolatey')

    $chocoExePath = Get-ChocolateyExeFilePath

    if (-not $chocoExePath) {
        Install-Chocolatey -Force $Force

        $chocoExePath = Get-ChocolateyExeFilePath
        if (-not $chocoExePath) {
            Write-Error ($LocalizedData.InstallChocolateyFailed)         
        }
    }

    if ($chocoExePath) {
        Write-Debug ($LocalizedData.ChocoCommandStart -f "$chocoExePath $Command $Arguments")
        $result = (& "$chocoExePath" $Command $Arguments)
        Write-Debug ($LocalizedData.ChocoCommandFinished -f "$chocoExePath $Command $Arguments")
        return $result
    }
}
