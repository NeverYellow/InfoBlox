 [CmdletBinding()]
    param ( 

        [parameter(Mandatory=$true)]
        [string]$ComputerName,

        [parameter(Mandatory=$true)]
        [string]$Port,

        [parameter(Mandatory=$false)]
        [switch]$ShowTCP


    )

$IDS_SCRIPTNAME = 'Test-PortConnection'

try { 
  
    $HostFQDN = [system.net.dns]::GetHostByAddress(([system.net.dns]::GetHostByName($computername)).AddressList[0].IPAddressToString).Hostname

    Write-Verbose "$IDS_SCRIPTNAME : Resolved $computername to $HostFQDN, using that for further queries"
    Write-Verbose "$IDS_SCRIPTNAME : Creating new TCP object"
    $tcp=new-object System.Net.Sockets.TcpClient 
  
    Write-Verbose "$IDS_SCRIPTNAME : Trying to connect to $HostFQDN on Port $Port"
    $tcp.connect($HostFQDN, $Port) 

    Write-Output "Computer responded OK"
    
    $tcpInfo = $tcp
    $tcp.close() 

    if($ShowTCP) {
        return($tcpInfo)
    }
    
} 
catch { 
    Write-Output "$IDS_SCRIPTNAME : Host does not respond on this port!"
    break
}

