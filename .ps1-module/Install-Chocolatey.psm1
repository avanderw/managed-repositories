function Install-Chocolatey {
param()
    if ($env:ChocolateyInstall -eq $null) {
        Import-Module $PSScriptRoot\Assert-AdminRights.psm1
        Assert-AdminRights

        Invoke-Expression ((New-Object System.Net.WebClient).DownloadString('https://chocolatey.org/install.ps1'))
        Invoke-Expression "choco feature enable -n allowGlobalConfirmation"
    }
}

Export-ModuleMember -Function Install-Chocolatey