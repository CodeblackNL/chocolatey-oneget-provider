param (
    [string]$Version = '0.0.0.1'
)

$sourceFolder = Join-Path -Path $PSScriptRoot -ChildPath '..\src'
$moduleFolder = Join-Path -Path $env:ProgramFiles -ChildPath "WindowsPowershell\Modules\ChocoOneGet"
$installationFolder = Join-Path -Path $moduleFolder -ChildPath $version

try {
    # modify psd1 with requested version
    $filePath = (Get-ChildItem -Path $sourceFolder -Filter 'ChocoOneGet.psd1' -Recurse).FullName
    $originalFileContent = @(Get-Content -Path $filePath)
    $fileContent = @()
    foreach ($line in $originalFileContent) {
        if ($line -match "ModuleVersion(\W)*=(\W)*['""](?<version>.*)['""]") {
            $fileContent += $line.Replace(($Matches.version), $version)
        }
        else {
            $fileContent += $line
        }
    }

    # update psd1 with new version
    Set-Content -Path $filePath -Value $fileContent -Force

    # remove old installed versions
    Remove-Item -Path $moduleFolder -Recurse -Force -ErrorAction SilentlyContinue
    New-Item -Path $installationFolder -ItemType Directory -Force -ErrorAction SilentlyContinue | Out-Null
    # install new version
    Copy-item -Path "$sourceFolder\*" -Destination $installationFolder -Recurse -Force

    Push-Location -Path $sourceFolder
    Get-ChildItem -Path $sourceFolder -Filter '*.nuspec' -Recurse |% {
        $nuspecFilePath = Join-Path -Path $_.DirectoryName -ChildPath "$($_.BaseName).$Version.nuspec"
        Copy-Item -Path $_.FullName -Destination $nuspecFilePath -Force

        [xml]$nuspec = Get-Content -Path $nuspecFilePath
        $nuspec.package.metadata.version = $Version
        $nuspec.Save($nuspecFilePath)

        choco pack $nuspecFilePath

        Remove-Item -Path $nuspecFilePath -Force
    }
    Pop-Location
}
finally {
    # restore original psd1
    Set-Content -Path $filePath -Value $originalFileContent -Force
}

<#

Register-PackageSource -ProviderName choco -Name uplab -Location '\\upvm-dsc\InstallationShare\Packages' -Trusted -Force
Get-PackageSource -ProviderName choco
Install-Package -ProviderName choco -Name dummy -Source uplab -Force

#>
