function Assert-AdminRights {
param()
    if (!([Security.Principal.WindowsPrincipal][Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole] "Administrator")) {
        Write-Error 'Administrator rights are required for the script to function.'
        exit(1)
    }
}

Export-ModuleMember -Function Assert-AdminRights