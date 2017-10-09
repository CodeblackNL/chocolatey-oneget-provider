
function Test-CoreCLR {
    $PSVariable = Get-Variable -Name IsCoreCLR -ErrorAction Ignore
    return ($PSVariable -and $PSVariable.Value)
}
