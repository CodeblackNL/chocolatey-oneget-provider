
function Test-NanoServer {
    try {
        # Check if this is nano server. [System.Runtime.Loader.AssemblyLoadContext] is only available on NanoServer
        [System.Runtime.Loader.AssemblyLoadContext]
        return $true
    }
    catch {
        return $false
    }
}
