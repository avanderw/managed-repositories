Import-Module .\.ps1-module\Install-Maven.psm1
Import-Module .\.ps1-module\Install-GraphViz.psm1
Install-Maven
Install-GraphViz
Remove-Module Install-Maven
Remove-Module Install-GraphViz

Write-Host "Digital Solutions: Dependency Graph"

Remove-Item –Path ./tmp –Recurse
New-Item ./tmp/dependencies -Type Directory -Force | Out-Null
$baseDirectory = Resolve-Path .
$workingDirectory = Resolve-Path ./tmp/dependencies

$projects = Get-Content './projects.json' | Out-String | ConvertFrom-Json
foreach ($project in $projects) {
    Write-Host "Creating dependency tree for project $($project.name)"

    Set-Location -Path "$baseDirectory/../$($project.name)"
    Invoke-Expression "mvn dependency:tree -Dincludes=capitec -DoutputType=dot"
    Get-ChildItem -Path .\ -Recurse -Include *.dependencies | Copy-Item -Recurse -Force -Destination "$workingDirectory\_$($project.name).dep"
    Set-Location -Path $baseDirectory
}

# processing dependencies
$unpackedFilename = "unpacked-projects"
$packedFilename = "packed-projects"
$processedFilename = "all-projects"
Set-Location -Path $workingDirectory
Get-ChildItem -Path "./*.dep" | Foreach { Get-Content $($_.name) | %{ $_ -replace ":(jar|war|pom)[`\w`\.`\-`\:`\s`\(`\)`\[`\]`\,]*","" } | Out-File -Encoding ascii .\$($_.name).clean }
Get-ChildItem -Path "./*.clean" | Foreach  {Invoke-Expression "dot $($_.name) -O"}
Get-Content .\*.dot | Add-Content .\${unpackedFilename}.dot
&'C:\Program Files (x86)\Graphviz2.38\bin\gvpack.exe' "-u" "-o${packedFilename}.dot" ".\${unpackedFilename}.dot"
Get-Content ./${packedFilename}.dot | %{ $_ -replace "_gv\d*","" } | Out-File -Encoding ascii .\${processedFilename}.dot
"strict " + (Get-Content ./${processedFilename}.dot -Raw) | Set-Content ./${processedFilename}.dot

# create PDFs and SVGs
& "C:\Program Files (x86)\Graphviz2.38\bin\dot.exe" "-Granksep=2" "-Gnodesep=.125" "-Grankdir=LR" "-Gsplines=true" "-Nshape=box" "-Nfontsize=64" "-Earrowhead=inv" "-Earrowsize=2" "-Estyle=solid" ".\${processedFilename}.dot" "-Tsvg" "-o${processedFilename}-dot.svg"
& "C:\Program Files (x86)\Graphviz2.38\bin\dot.exe" "-Granksep=2" "-Gnodesep=.125" "-Grankdir=LR" "-Gsplines=true" "-Nshape=box" "-Nfontsize=64" "-Earrowhead=inv" "-Earrowsize=2" "-Estyle=solid" ".\${processedFilename}.dot" "-Tpdf" "-o${processedFilename}-dot.pdf"
& "C:\Program Files (x86)\Graphviz2.38\bin\twopi.exe" "-Goverlap=false" "-Gsplines=true" "-Nshape=box" "-Nfontsize=64" "-Earrowhead=inv" "-Earrowsize=1" ".\${processedFilename}.dot" "-Tsvg" "-o${processedFilename}-twopi.svg"
& "C:\Program Files (x86)\Graphviz2.38\bin\twopi.exe" "-Goverlap=false" "-Gsplines=true" "-Nshape=box" "-Nfontsize=64" "-Earrowhead=inv" "-Earrowsize=1" ".\${processedFilename}.dot" "-Tpdf" "-o${processedFilename}-twopi.pdf"
& "C:\Program Files (x86)\Graphviz2.38\bin\neato.exe" "-Goverlap=false" "-Gsplines=true" "-Nshape=box" "-Nfontsize=64" "-Earrowhead=inv" "-Earrowsize=1" ".\${processedFilename}.dot" "-Tsvg" "-o${processedFilename}s-neato.svg"
& "C:\Program Files (x86)\Graphviz2.38\bin\neato.exe" "-Goverlap=false" "-Gsplines=true" "-Nshape=box" "-Nfontsize=64" "-Earrowhead=inv" "-Earrowsize=1" ".\${processedFilename}.dot" "-Tpdf" "-o${processedFilename}-neato.pdf"
Set-Location -Path $baseDirectory