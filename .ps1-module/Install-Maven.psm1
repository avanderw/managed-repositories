function Install-Maven {
param()
    if ($env:M2_HOME -eq $null) {
        Import-Module $PSScriptRoot\Install-Chocolatey.psm1
        Install-Chocolatey

        Invoke-Expression "choco install maven"

        $mavenSettingsInputFilePathAndName = "\\cb0264\c$\Users\s_bamboo\.m2\settings.xml"
        $mavenSettingsOutputFilePathAndName = [Environment]::GetFolderPath("UserProfile") + "/.m2/settings.xml"
        $mavenSettingsBackupFilePathAndName = [Environment]::GetFolderPath("UserProfile") + "/.m2/settings.xml.backup-$(get-date -f yyyy-MM-dd_HH_mm_ss)"
        
        Copy-Item -Path $mavenSettingsOutputFilePathAndName -Destination $mavenSettingsBackupFilePathAndName
        Copy-Item -Path $mavenSettingsInputFilePathAndName -Destination $mavenSettingsOutputFilePathAndName

    }
}
Export-ModuleMember -Function Install-Maven