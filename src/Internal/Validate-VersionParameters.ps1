
function Validate-VersionParameters {
    param (
        [Parameter()]
        [String[]]
        $Name,

        [Parameter()]
        [String]
        $MinimumVersion,

        [Parameter()]
        [String]
        $RequiredVersion,

        [Parameter()]
        [String]
        $MaximumVersion,

        [Parameter()]
        [Switch]
        $AllVersions
    )

    if ($AllVersions -and ($RequiredVersion -or $MinimumVersion -or $MaximumVersion)) {
        Throw-Error -ExceptionName "System.ArgumentException" `
                    -ExceptionMessage $LocalizedData.AllVersionsCannotBeUsedWithOtherVersionParameters `
                    -ErrorId 'AllVersionsCannotBeUsedWithOtherVersionParameters' `
                    -CallerPSCmdlet $PSCmdlet `
                    -ErrorCategory InvalidArgument
    }
    elseif ($RequiredVersion -and ($MinimumVersion -or $MaximumVersion)) {
        Throw-Error -ExceptionName "System.ArgumentException" `
                    -ExceptionMessage $LocalizedData.VersionRangeAndRequiredVersionCannotBeSpecifiedTogether `
                    -ErrorId "VersionRangeAndRequiredVersionCannotBeSpecifiedTogether" `
                    -CallerPSCmdlet $PSCmdlet `
                    -ErrorCategory InvalidArgument
    }
    elseif ($MinimumVersion -and $MaximumVersion -and ($MinimumVersion -gt $MaximumVersion)) {
        $Message = $LocalizedData.MinimumVersionIsGreaterThanMaximumVersion -f ($MinimumVersion, $MaximumVersion)
        Throw-Error -ExceptionName "System.ArgumentException" `
                    -ExceptionMessage $Message `
                    -ErrorId "MinimumVersionIsGreaterThanMaximumVersion" `
                    -CallerPSCmdlet $PSCmdlet `
                    -ErrorCategory InvalidArgument
    }
    elseif ($AllVersions -or $RequiredVersion -or $MinimumVersion -or $MaximumVersion) {
        #if (-not $Name -or $Name.Count -ne 1 -or ([System.Management.Automation.WildcardPattern]::ContainsWildcardCharacters($Name[0]))) {
        #    Throw-Error -ExceptionName "System.ArgumentException" `
        #                -ExceptionMessage $LocalizedData.VersionParametersAreAllowedOnlyWithSingleName `
        #                -ErrorId "VersionParametersAreAllowedOnlyWithSingleName" `
        #                -CallerPSCmdlet $PSCmdlet `
        #                -ErrorCategory InvalidArgument
        #}
    }

    return $true
}

