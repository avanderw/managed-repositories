function Install-GraphViz {
param()
    if ((Get-Command "dot.exe" -ErrorAction SilentlyContinue) -eq $null) {
        Import-Module $PSScriptRoot\Install-Chocolatey.psm1
        Install-Chocolatey

        Invoke-Expression "choco install graphviz"
    }
}
Export-ModuleMember -Function Install-GraphViz