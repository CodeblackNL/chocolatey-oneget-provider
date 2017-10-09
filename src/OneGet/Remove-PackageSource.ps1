
function Remove-PackageSource {
    param (
        [string]
        $Name
    )

    Write-Debug ($LocalizedData.ProviderDebugMessage -f ' Remove-PackageSource')

    if ([System.Management.Automation.WildcardPattern]::ContainsWildcardCharacters($Name)) {
        $message = $LocalizedData.PackageSourceNameContainsWildCards -f $Name
        Write-Error -Message $message -ErrorId 'PackageSourceNameContainsWildCards' -Category InvalidOperation -TargetObject $Name
        return
    }

    $force = Get-ForceOption

    $packageSource = Resolve-PackageSource -Force $force | Where-Object { $_.Name -eq $Name }
    if (-not $packageSource) {
        $message = $LocalizedData.PackageSourceNotFound -f $Name
        Write-Error -Message $message -ErrorId 'PackageSourceNotFound' -Category InvalidOperation -TargetObject $Name
        return
    }

    $arguments = @(
        'remove'
        "--name='$Name'"
    )
    Invoke-Chocolatey -Command 'source' -Arguments $arguments -Force $force

    Write-Debug ($LocalizedData.PackageSourceUnregistered -f ($Name, $Location))
}