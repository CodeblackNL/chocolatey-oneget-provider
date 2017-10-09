
function Get-DynamicOptions {
    param (
        [Microsoft.PackageManagement.MetaProvider.PowerShell.OptionCategory] 
        $category
    )

    Write-Debug ($LocalizedData.ProviderDebugMessage -f ('Get-DynamicOptions'))

    switch ($category) {
        Package {
            Write-Output -InputObject (New-DynamicOption -Category $category -Name $script:prerelease -ExpectedType Switch -IsRequired $false)

            # TODO: add support for: timeout, proxy, approved-only, not-broken
        }
        Install {
            #Write-Output -InputObject (New-DynamicOption -Category $category -Name $script:additionalArguments -ExpectedType String -IsRequired $false)

            Write-Output -InputObject (New-DynamicOption -Category $category -Name $script:prerelease -ExpectedType Switch -IsRequired $false)
            Write-Output -InputObject (New-DynamicOption -Category $category -Name $script:packageParameters -ExpectedType String -IsRequired $false)
            Write-Output -InputObject (New-DynamicOption -Category $category -Name $script:ignoreDependencies -ExpectedType Switch -IsRequired $false)
            Write-Output -InputObject (New-DynamicOption -Category $category -Name $script:forceDependencies -ExpectedType Switch -IsRequired $false)
            Write-Output -InputObject (New-DynamicOption -Category $category -Name $script:skipPowershell -ExpectedType Switch -IsRequired $false)
            Write-Output -InputObject (New-DynamicOption -Category $category -Name $script:cacheLocation -ExpectedType String -IsRequired $false)

            # special option for passing switches from the PackageManagement DSC-resource
            Write-Output -InputObject (New-DynamicOption -Category $category -Name $script:switches -ExpectedType String -IsRequired $false)

            # TODO: add support for: timeout, proxy, approved-only, not-broken
            # TODO: add support for: install-arguments
        }
    }
}
