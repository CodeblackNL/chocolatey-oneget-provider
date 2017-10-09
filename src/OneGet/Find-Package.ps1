
function Find-Package {
    param (
        [string]
        $Name,
        
        [string]
        $RequiredVersion,
        
        [string]
        $MinimumVersion,
        
        [string]
        $MaximumVersion
    )

    Write-Debug ($LocalizedData.ProviderDebugMessage -f ' Find-Package')

    $allVersions = Get-AllVersionsOption
    $validVersions = Validate-VersionParameters  -Name $Name `
                                                 -MinimumVersion $MinimumVersion `
                                                 -MaximumVersion $MaximumVersion `
                                                 -RequiredVersion $RequiredVersion `
                                                 -AllVersions:$allVersions
    if (-not $validVersions) {
        return
    } 

    $nameContainsWildCard = [System.Management.Automation.WildcardPattern]::ContainsWildcardCharacters($Name)
    $filterRequired = $false
    $nameContainWildCard = $false      

    if (-not $Name) {
        # if a user does not provide a name, the entire repo will be searched; let's not do that
        Write-Error ($LocalizedData.SearchingEntireRepo)
        return
    }

    $progress = 5
    Write-Progress -Activity $LocalizedData.SearchingForPackage -PercentComplete $progress -Id $script:FindPackageProgressId

    $force = Get-ForceOption

    $packageSources = @(Resolve-PackageSource -Force $force)
    if ($packageSources) {
        # choco does not support wildcard search, so remove them from start & end of the name and filter later
        $arguments = @(
            $Name.Trim('*','?')
        )
        if ($RequiredVersion -or (Get-PrereleaseOption)) {
            $arguments += '--prerelease'
        }
        # choco does not support version search, so we'll find all-versions first and filter later
        if ($allVersions -or $RequiredVersion -or $MinimumVersion -or $MaximumVersion) {
            $arguments += '--allversions'
        }

        $packageSourceScriptBlock = {
            param ([Array]$ChocoArguments)

            $location = $_.Location
            $ChocoArguments += "--source='$($location)'"

            Invoke-Chocolatey -Command 'search' -Arguments $ChocoArguments -Force $force | ForEach-Object {
                New-Object -TypeName 'PSCustomObject' -Property @{
                    Package = $_
                    Location = $location
                }
            }
        }

        if ($packageSources.Length -eq 1) {
            $_ = $packageSources[0]
            $chocoPackages = $packageSourceScriptBlock.Invoke(@(,$Arguments))
        }
        else {
            #$chocoPackages = $packageSources | ForEach-Parallel -ScriptBlock $packageSourceScriptBlock -ArgumentList $Arguments
            $progressStep = (70 - $progress) / $packageSources.Length
            $index = 0
            $chocoPackages = $packageSources | ForEach-Object {
                $packageSourceScriptBlock.Invoke(@(,$Arguments))

                $index++
                Write-Progress -Activity $LocalizedData.SearchingForPackage -PercentComplete ([System.Math]::Min(70, $progress + ($index * $progressStep))) -Id $script:FindPackageProgressId 
            }
        }
    }
   
    $chocoPackagesPerLocation = $chocoPackages | Group-Object -Property 'Location'

    $progress = 70
    Write-Progress -Activity $LocalizedData.SearchingForPackage -PercentComplete $progress -Id $script:FindPackageProgressId

    $chocoPackagesPerLocation | ForEach-Object {
        $location = $_.Name
        Process-Package -Packages $_.Group.Package `
                        -Name $Name -NameContainsWildCard $nameContainsWildCard `
                        -Source $_.Name `
                        -RequiredVersion $RequiredVersion `
                        -MinimumVersion $MinimumVersion `
                        -MaximumVersion $MaximumVersion `
                        -ProgressStart $progress -ProgressEnd 100 -ProgressId $script:FindPackageProgressId
    }
    
    Write-Progress -Activity $LocalizedData.Complete -PercentComplete 100 -Completed -Id $script:FindPackageProgressId               
}                    

<# TODO: use --verbose to get detailed package-info, including Summary

choco list --verbose

notepadplusplus 7.5 [Approved]
 Title: Notepad++ | Published: 15-Aug-17
 Package approved by flcdrg on Aug 21 2017 02:03:23.
 Package testing status: Passing on Aug 16 2017 00:44:02.
 Number of Downloads: 910176 | Downloads for this version: 11520
 Package url
 Chocolatey Package Source: https://github.com/chocolatey/chocolatey-coreteampackages/tree/master/automatic/notepadplusplus
 Package Checksum: 'JtblQAkYWV19lypc1xrnmY7EWK47qSqNr8a85dy5RiZHxtAWYuhR45UilqXbV41wJodBWzQug7sHLyC3+5ILtw==' (SHA512)
 Tags: notepad notepadplusplus notepad-plus-plus editor text development foss
 Software Site: https://notepad-plus-plus.org/
 Software License: https://github.com/notepad-plus-plus/notepad-plus-plus/blob/master/LICENSE
 Software Source: https://github.com/notepad-plus-plus/notepad-plus-plus
 Mailing List: https://notepad-plus-plus.org/community/
 Issues: https://github.com/notepad-plus-plus/notepad-plus-plus/issues
 Summary: Notepad++ is a free (as in "free speech" and also as in "free beer") source code editor and Notepad replacement that supports several languages.
 Description: Notepad++ is a free (as in "free speech" and also as in "free beer") source code editor and Notepad replacement that supports several languages. Running in the MS Windows environment, its use i
s governed by GPL License.

  Based on the powerful editing component Scintilla, Notepad++ is written in C++ and uses pure Win32 API and STL which ensures a higher execution speed and smaller program size. By optimizing as many routine
s as possible without losing user friendliness, Notepad++ is trying to reduce the world carbon dioxide emissions. When using less CPU power, the PC can throttle down and reduce power consumption, resulting i
n a greener environment.

  ## Features


  * Syntax Highlighting and Syntax Folding
  * User Defined Syntax Highlighting and Folding: [screenshot 1](https://notepad-plus-plus.org/assets/images/scsh/ulds_folder.gif), [screenshot 2](https://notepad-plus-plus.org/assets/images/scsh/ulds_keywor
ds.gif), [screenshot 3](https://notepad-plus-plus.org/assets/images/scsh/ulds_comment.gif) and [screenshot 4](https://notepad-plus-plus.org/assets/images/scsh/ulds_op.gif)
  * PCRE (Perl Compatible Regular Expression) Search/Replace
  * GUI entirely customizable: [minimalist](https://notepad-plus-plus.org/assets/images/scsh/scsh_gui_minimalist.png), [tab with close button](https://notepad-plus-plus.org/assets/images/scsh/scsh_gui_tabClo
seButton.png), [multi-line tab](https://notepad-plus-plus.org/assets/images/scsh/scsh_gui_multiLineTab.png), [vertical tab](https://notepad-plus-plus.org/assets/images/scsh/scsh_gui_verticalTab.png) and [ver
tical document list](https://notepad-plus-plus.org/assets/images/scsh/scsh_gui_verticalDocList.png)
  * [Document Map](https://notepad-plus-plus.org/assets/images/docMap.png)
  * Auto-completion: Word completion, Function completion and Function parameters hint
  * Multi-Document (Tab interface)
  * Multi-View
  * WYSIWYG (Printing)
  * Zoom in and zoom out
  * Multi-Language environment supported
  * Bookmark
  * Macro recording and playback
  * Launch with different [arguments](https://notepad-plus-plus.org/assets/images/scsh/scsh_cmdlineArguments.png)

  ## Notes

  - To force the installation of x32 version, use the `--x86` argument with `choco install`.
 Release Notes: https://notepad-plus-plus.org/news
#>
