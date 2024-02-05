Write-Output "Reloading InfoBloxTools module`n"

Write-Output 'Removing InfoBloxTools module from memory'
Remove-Module IBToolKit
Write-Output 'Importing InfoBloxTools module'
Import-Module IBToolKit
