@{
    RootModule = 'ChocoOneGet'
    ModuleVersion = '0.0.0.1'
    GUID = '1b346044-bb77-44c1-b3b2-b7a85ef866fd'
    Author = 'Codeblack'
    Copyright = '(c) 2017 Codeblack. All rights reserved.'
    Description = 'OneGet provider for Chocolatey'
    PowerShellVersion = '5.0'

    RequiredModules = @('PackageManagement')

    FunctionsToExport = @('*')
    CmdletsToExport = @()
    VariablesToExport = '*'
    AliasesToExport = @()

    PrivateData = @{
        PackageManagementProviders = 'ChocoOneGet.psm1'
        PSData = @{

            # Tags applied to this module to indicate this is a PackageManagement Provider.
            Tags = @("PackageManagement","Provider")

            # A URL to the license for this module.
            LicenseUri = 'https://github.com/CodeblackNL/chocolatey-oneget-provider/blob/master/LICENSE'

            # A URL to the main website for this project.
            ProjectUri = 'https://github.com/CodeblackNL/chocolatey-oneget-provider'

            # ReleaseNotes of this module
            ReleaseNotes = 'OneGet provider for Chocolatey; implemented as a PowerShell module, it wraps choco.exe.'
        }
    }
}

