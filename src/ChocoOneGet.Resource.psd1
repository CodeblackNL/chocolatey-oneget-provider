ConvertFrom-StringData @'
###PSLOC
        ProviderDebugMessage='ChocoOneGet': '{0}'.

        ChocoFound=Found choco.exe in '{0}'.
        ChocoCommandStart=Executing choco: '{0}'.
        ChocoCommandFinished=Executed choco: '{0}'.
        
        PackageSourceNameContainsWildCards=The package source name '{0}' should not have wildcards, correct it and try again.
        PackageSourceRegistered=Successfully registered package source '{0}' with location '{1}'.
        PackageSourceUnregistered=Successfully unregistered Package source '{0}'.
        
        AllVersionsCannotBeUsedWithOtherVersionParameters=You cannot use the parameter AllVersions with RequiredVersion, MinimumVersion or MaximumVersion in the same command.
        VersionRangeAndRequiredVersionCannotBeSpecifiedTogether=You cannot use the parameters RequiredVersion and either MinimumVersion or MaximumVersion in the same command. Specify only one of these parameters in your command.
        MinimumVersionIsGreaterThanMaximumVersion=The specified MinimumVersion '{0}' is greater than the specified MaximumVersion '{1}'.
        VersionParametersAreAllowedOnlyWithSingleName=The RequiredVersion, MinimumVersion, MaximumVersion or AllVersions parameters are allowed only when you specify a single name as the value of the Name parameter, without any wildcard characters.

        FindingLocalPackage=Finding local packages
        SearchingForPackage=Searching for packages
        ProcessingPackage=Processing package
        Complete=Complete
        SearchingEntireRepo=Searching entire repo's is not supported. Please specify package name.

        FastPackageReference='ChocoOneGet': The FastPackageReference is '{0}'.
        ShouldContinue=Are you sure you want to perform this action?

        InstallingPackage=Installing package
        InstallFailedInvalidFastReference=Failed to install the package because the fast reference '{0}' is incorrect.
        InstallPackageQuery=Installing package '{0}'. By installing you accept licenses for the package(s). The package possibly needs to run 'chocolateyInstall.ps1'. 
        InstallCancelled=Install of package '{0}' has been cancelled.
        InstallFailed=Package '{0}' is not installed.
        AlreadyInstalled=Package '{0} {1}' is already installed.

        UninstallingPackage=UnInstalling package
        UninstallFailedInvalidFastReference=Failed to uninstall the package because the fast reference '{0}' is incorrect.
        UninstallPackageQuery=Uninstalling package '{0}'. The package possibly needs to run 'chocolateyUninstall.ps1'. 
        UninstallCancelled=Uninstall of package '{0}' has been cancelled.
        UninstallFailed=Package '{0}' is not uninstalled.
        NotInstalled=Package '{0} {1}' is not installed.

        SavePackageNotSupported='ChocoOneGet': Save-Package is not supported because chocolatey does not support downloading packages.

        ChocoUnSupportedOnCoreCLR='ChocoOneGet': chocolatey is not supported on CoreCLR (Nano Server or *nix).
        ChocoAlreadyInstalled=Chocolatey is already installed.
        InstallChocolateyShouldContinueCaption=Chocolatey is required to continue
        InstallChocolateyShouldContinueQuery=ChocoOneGet is built on chocolatey. Do you want ChocoOneGet to install chocolatey now?        
        UserDeclinedInstallChocolatey=User declined to install chocolatey.
        InstallChocolateyFailed=Chocolatey installed failed. You may relaunch PowerShell as elevated mode and try again.



        SearchVersionNotSupported='ChocoOneGet': chocolatey does not support seaching for a specific version. Returning all versions instead.

        OperationFailed='{0}' '{1}' Failed. You may relaunch PowerShell as elevated mode and try again with -Verbose -Debug to get more information.
        FoundNewerChocolatey=Found Chocolatey version '{0}' is greater than the installed one '{1}'
        InvalidVersionFormat=Version '{0}' does not match the regex '{1}'

        NameShouldNotContainWildcardCharacters=The specified name '{0}' should not contain any wildcard characters, please correct it and try again.
        RequiredVersionAllowedOnlyWithSingleModuleName=The RequiredVersion parameter is allowed only when a single module name is specified as the value of the Name parameter, without any wildcard characters.
      
        
###PSLOC
'@