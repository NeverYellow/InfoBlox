Write-Output 'Updating InfoBloxTools PS Module'

$PublicFunctionFile  = 'PublicFunctions.txt'
$PrivateFunctionFile = 'PrivateFunctions.txt'

$FileListPublic  = Get-Content $PSScriptRoot\$PublicFunctionFile
$FileListPrivate = get-Content $PSScriptRoot\$PrivateFunctionFile

Write-Output 'Updating Public Functions'

foreach ($file in $FileListPublic) {
    Write-Output "Updating / Adding : $($File)"
    Copy-Item $PSScriptRoot\$($file) \PersonalModules\IBToolKit\Public
}

Write-Output 'Updating Private Functions'

foreach ($file in $FileListPrivate) {
    Write-Output "Updating / Adding : $($File)"
    Copy-Item $PSScriptRoot\$($file) \PersonalModules\IBToolKit\Private
}

