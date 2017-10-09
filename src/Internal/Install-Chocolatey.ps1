
function Install-Chocolatey {
    [CmdletBinding()]
    [OutputType([bool])]
    param (
        [bool]
        $Force
    )

    if (Test-NanoServer -or Test-CoreCLR) {
        Write-Error ($LocalizedData.ChocoUnSupportedOnCoreCLR)
        return
    }
  
    $chocoExePath = Get-ChocolateyExeFilePath
    if($chocoExePath -and (Test-Path -Path $chocoExePath -PathType Leaf))
    {
        Write-Debug ($LocalizedData.ChocoAlreadyInstalled)
        return
    }

    #$shouldContinueCaption = $LocalizedData.InstallChocolateyShouldContinueCaption
    #$shouldContinueQueryMessage = $LocalizedData.InstallChocolateyShouldContinueQuery
    #if (-not ($Force -or $request.ShouldContinue($shouldContinueQueryMessage, $shouldContinueCaption))) {
    #    Write-Error $LocalizedData.UserDeclinedInstallChocolatey
    #    return       
    #}

    try {
		# determine location of included chocolatey-package & unzip-tool
        $filePath = (Get-ChildItem -Path (Join-Path -Path $PSScriptRoot -ChildPath '..\Files') -Filter 'chocolatey.*.nupkg*' | Sort NameLastWriteTime | Select -Last 1).FullName
        $7zaExe = Join-Path -Path $PSScriptRoot -ChildPath '..\Files\7za.exe'

		# determine temp-location
        $tempFolderPath = Join-Path -Path $env:windir -ChildPath 'Temp\chocolatey'
        New-Item -Path $tempFolderPath -ItemType Directory -Force

        # unzip the package
        Write-Verbose "Extracting '$filePath' to '$tempFolderPath'..."
        Start-Process "$7zaExe" -ArgumentList "x -o`"$tempFolderPath`" -bd -y `"$filePath`"" -Wait -NoNewWindow

        #Write-Verbose 'Setting ChocolateyInstall environment variables...'
        #[Environment]::SetEnvironmentVariable('ChocolateyInstall', $chocoPath, [EnvironmentVariableTarget]::Machine)
        #$env:ChocolateyInstall = [Environment]::GetEnvironmentVariable('ChocolateyInstall','Machine')
        #Write-Verbose "Env:ChocolateyInstall has '$($env:ChocolateyInstall)'"

        # call chocolatey install
        Write-Verbose "Installing chocolatey on this machine..."
        $toolsFolder = Join-Path -Path $tempFolderPath -ChildPath 'tools'
        $installFilePath = Join-Path -Path $toolsFolder -ChildPath 'chocolateyInstall.ps1'
        & $installFilePath

        Write-Verbose 'Ensuring chocolatey commands are on the path...'
        $chocoPath = Join-Path -Path $env:ALLUSERSPROFILE -ChildPath 'Chocolatey'
        $chocoExePath = Join-Path -Path $chocoPath -ChildPath 'bin'
        $env:Path = [Environment]::GetEnvironmentVariable('Path',[System.EnvironmentVariableTarget]::Machine)
        if ($env:path -notlike "*$chocoExePath*") {
            $env:Path += ";$chocoExePath"
        }
        Write-Verbose "Env:Path has '$($env:Path)'"

        Write-Verbose 'Ensuring chocolatey.nupkg is in the lib folder'
        $chocoPackageFolderPath = Join-Path -Path $chocoPath -ChildPath 'lib\chocolatey'
        $chocoPackageFilePath = Join-Path -Path $chocoPackageFolderPath -ChildPath 'chocolatey.nupkg'
        if (![System.IO.Directory]::Exists($chocoPackageFolderPath)) {
			[System.IO.Directory]::CreateDirectory($chocoPackageFolderPath)
		}
        Copy-Item -Path "$filePath" -Destination "$chocoPackageFilePath" -Force -ErrorAction SilentlyContinue

        $null = choco
        Write-Verbose 'Finish installing chocolatey'
    }
    finally {
        if ($tempFolderPath -and (Test-Path $tempFolderPath)) {
            Remove-Item -Path $tempFolderPath -Recurse -Force
        }
    }
}
