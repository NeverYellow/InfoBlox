$ConnectionInfo = Import-clixml H:\PersonalModules\InfoBloxTools\Data\IBConnection.xml
$Password = $ConnectionInfo.SecurePassword | ConvertTo-SecureString

$username = $ConnectionInfo.Username
$Credential = New-Object System.Management.Automation.PSCredential $username,$Password 

$IBAPIServer  = $ConnectionInfo.Uri
$IBAPIVersion = $ConnectionInfo.APIVersion
$IBGrid       = '/grid'
$uri = $IBAPIServer+'/'+$IBAPIVersion+$IBGrid

$GridInfo = Invoke-RestMethod -Uri $uri -Credential $Credential -SessionVariable TempSession
