if ($PSVersionTable.PSVersion.Major -lt 3) {
    Write-Host ("at least powershell version 3 required, you have {0}" -f $PSVersionTable.PSVersion.Major)
    exit (1);
}

$projects = Get-Content './projects.json' | Out-String | ConvertFrom-Json
$gitignore = "# this file is generated by update.ps1`r`n";

foreach ($project in $projects) {
    $gitignore += "$( $project.name )/`r`n"
    Write-Host "---------------------------------------------------------------"
    Write-host "-- $( $project.name )  clone: $( $project.clone )"
    Write-Host "---------------------------------------------------------------"

	if (Test-Path ../$($project.name))
	{
		iex "git -C ../$( $project.name ) pull"
	}
	elseif ($($project.clone)) {
		iex "git clone $( $project.url ) ../$( $project.name )"
		
		# copy hooks
		Copy-Item -Path .\prepare-commit-msg.hook -Destination ("../{0}\.git\hooks\prepare-commit-msg" -f $project.name)
		Copy-Item -Path .\commit-msg.hook -Destination ("../{0}\.git\hooks\commit-msg" -f $project.name)
	}
}

# $gitignore | Out-File '.gitignore' -Encoding "utf8"