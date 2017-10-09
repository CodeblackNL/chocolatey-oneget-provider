function Resolve-PackageSource {
    Write-Debug ($LocalizedData.ProviderDebugMessage -f ' Resolve-PackageSource')

    $packageSourceNames = $request.PackageSources
    if (-not $packageSourceNames) {
        $packageSourceNames = '*'
    }

    $chocoSources = @(Invoke-Chocolatey -Command 'source' -Arguments 'list' -Force (Get-ForceOption) `
        | Where-Object {
            $_ -match $script:sourceRegex
        } `
        | ForEach-Object {
            @{
                Name = $Matches.name
                Location = $Matches.location
            }
        })

    foreach($packageSourceName in $packageSourceNames) {
        if ($request.IsCanceled) {
            return
        }

        $chocoSources `
            | Where-Object { $_.Name -and $_.Location -and $_.Name -like $packageSourceName } `
            | ForEach-Object {
                Write-Output -InputObject (New-PackageSource -Name $_.Name -Location $_.Location -Trusted $true -Registered $true)
            }
    }
}
