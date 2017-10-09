function Get-ChocolateyExeFilePath {
    [CmdletBinding()]
    [OutputType([string])]
    param ()

    $chocoExeName = 'choco.exe'
    $chocoExeDefaultFilePath = 'C:\ProgramData\chocolatey\bin\choco.exe'
    
    $chocoCommad = Get-Command -Name $chocoExeName -ErrorAction SilentlyContinue -WarningAction SilentlyContinue `
        | Where-Object { 
            $_.Path -and 
            ((Split-Path -Path $_.Path -Leaf) -eq $chocoExeName) -and
            (-not $_.Path.StartsWith($env:windir, [System.StringComparison]::OrdinalIgnoreCase)) 
        } | Select-Object -First 1

    if ($chocoCommad -and $chocoCommad.Path) {
        Write-Debug ($LocalizedData.ChocoFound -f $chocoCommad.Path)
        return $chocoCommad.Path
    }
    elseif (Test-Path -Path $chocoExeDefaultFilePath -PathType Leaf) {
        return $chocoExeDefaultFilePath
    }
    else {
        return $null
    }
}
