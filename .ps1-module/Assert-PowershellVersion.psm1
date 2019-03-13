function Assert-PowershellVersion {
param(
    [Int] $major
)
    if ($PSVersionTable.PSVersion.Major -lt $major) { 
        Write-Error ("At least Powershell version $major required, you have {0}" -f $PSVersionTable.PSVersion.Major)
        exit (1)
    }
}
Export-ModuleMember -Function Assert-PowershellVersion