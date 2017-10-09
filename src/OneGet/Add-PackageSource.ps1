
<#
choco source add -n=bob -s="https://somewhere/out/there/api/v2/"
choco source add -n=bob -s "'https://somewhere/out/there/api/v2/'" -cert=\Users\bob\bob.pfx
choco source add -n=bob -s "'https://somewhere/out/there/api/v2/'" -u=bob -p=12345
choco source disable -n=bob
choco source enable -n=bob
choco source remove -n=bob
#>

function Add-PackageSource {
    [CmdletBinding()]
    param (
        [string]
        $Name,

        [string]
        $Location,

        [bool]
        $Trusted
    )     

    Write-Debug ($LocalizedData.ProviderDebugMessage -f ' Add-PackageSource')

    if ([System.Management.Automation.WildcardPattern]::ContainsWildcardCharacters($Name)) {
        Throw-Error -ExceptionName 'System.ArgumentException' `
                    -ExceptionMessage ($LocalizedData.PackageSourceNameContainsWildCards -f ($Name)) `
                    -ErrorId 'PackageSourceNameContainsWildCards' `
                    -CallerPSCmdlet $PSCmdlet `
                    -ErrorCategory InvalidArgument `
                    -ExceptionObject $Name
        return
    }

    $arguments = @(
        'add'
        "--name='$Name'"
        "--source='$Location'"
    )
    Invoke-Chocolatey -Command 'source' -Arguments $arguments -Force (Get-ForceOption)

    Write-Debug ($LocalizedData.PackageSourceRegistered -f ($Name, $Location))

    Write-Output -InputObject (New-PackageSource -Name $Name -Location $Location -Trusted $true -Registered $true)
}
