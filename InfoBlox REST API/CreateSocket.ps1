[CmdletBinding()]
    [OutputType()]
    Param (
        [String]$Server = '172.30.66.21'
    )

[Byte[]]$NtpData = ,0 * 48
$NtpData[0] = 0x1B    # NTP Request header in first byte

$Socket = New-Object Net.Sockets.Socket([Net.Sockets.AddressFamily]::InterNetwork,[Net.Sockets.SocketType]::Dgram,[Net.Sockets.ProtocolType]::Udp)
$Socket.SendTimeOut = 2000  # ms
$Socket.ReceiveTimeOut = 2000   # ms

  Try {
        $Socket.Connect($Server,123)
    }
    Catch {
        Write-Error "Failed to connect to server $Server"
        Throw 
    }


# NTP Transaction -------------------------------------------------------

        $t1 = Get-Date    # t1, Start time of transaction... 
    
        Set
        Try {
            [Void]$Socket.Send($NtpData)
            [Void]$Socket.Receive($NtpData)  
        }
        Catch {
            Write-Error "Failed to communicate with server $Server"
            #Throw
        }

$Socket.Shutdown("Both") 
$Socket.Close()

$Mode = ($NtpData[0] -band 0x07)     # Server mode (probably 'server')
    $Mode_text = Switch ($Mode) {
        0    {'reserved'}
        1    {'symmetric active'}
        2    {'symmetric passive'}
        3    {'client'}
        4    {'server'}
        5    {'broadcast'}
        6    {'reserved for NTP control message'}
        7    {'reserved for private use'}
    }

Write-Host "Client is : $Mode_text"
