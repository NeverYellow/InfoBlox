function returnmatch {

param ($ref)

$ref -match "record:host/([^;]*):" | Out-Null 

return $Matches[1]

}


$Credential = Get-Credential

$computer = $Env:COMPUTERNAME
$dnsName  = $env:USERDNSDOMAIN

$vmhostname = $computer+'.'+$dnsName

Write-Verbose "Executing GET Request on $vmhostname.domain.com"
$webrequest = Invoke-WebRequest -Uri "https://172.30.66.21/wapi/v1.7.5/record:host?name=" -Credential $Credential
$b=$webrequest.Content | ConvertFrom-Json


$refnew = $b._ref

$b = $b | select @{l='Ref_ID';e={returnmatch -ref $refnew}},@{l='Host';e={($_ | select -ExpandProperty ipv4addrs).host}},@{l='IPV4Addr';e={($_ | select -ExpandProperty ipv4addrs).ipv4addr}}