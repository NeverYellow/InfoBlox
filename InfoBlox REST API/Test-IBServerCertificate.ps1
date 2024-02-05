function Test-IBServerCertificate() 
{

<#
	.SYNOPSIS
		Test presence of a server Certificate.

	.DESCRIPTION
		Test if the the InfoBlox Server Certificate is present in the Root / Local store

    .PARAMETER Server
        InfoBlox Server name to test
        
    .PARAMETER RootCertificates
        Lists Certificates from the LocalMachine Root Store (Formatted)

    .PARAMETER PersonalCertificates
        Returns the information in Raw format (works only in conjunction with ListRootCertificates)

	.EXAMPLE
		Test-IBServerCertificate -Server <infoblox-gridmaster>


        
#>

    [CmdletBinding()]
    Param(
        [parameter(Mandatory=$false)]
        [string]$Server,
        
        [parameter(Mandatory=$false)]
        [ValidateSet('Root','Personal')]
        [string]$ListCertificate

    )

    $IDS_SCRIPTNAME = 'Test-IBServerCertificate'

    if( ([string]::IsNullOrEmpty($ListCertificate)) -eq $false) {
        switch($ListCertificate) { 
            'Root' { 
                Write-Verbose "$IDS_SCRIPTNAME : List Root Store Certificates"
                $Store = new-object System.Security.Cryptography.X509Certificates.X509Store([System.Security.Cryptography.X509Certificates.StoreName]::Root,"localmachine")
                $Store.open("ReadOnly") 
                $CertificateList = $Store.Certificates
                $Store.close()
                }
            'Personal' {
                Write-Verbose "$IDS_SCRIPTNAME : List Root Store Certificates"
                $Store = new-object System.Security.Cryptography.X509Certificates.X509Store([System.Security.Cryptography.X509Certificates.StoreName]::My,"localmachine")
                $Store.open("ReadOnly") 
                $CertificateList = $Store.Certificates
                $Store.close()
                Return($CertificateList)
            
                }
        default { Write-Host 'Invalid Parameter value. Use Root or Personal'; break }

        }

        return($CertificateList)

    }
    else {
        if([string]::IsNullOrEmpty($Server) -eq $true) { # Server name is an empty string
            Write-output "Server not specified, using default IB Connection Info"
            $ConnectionInfo = Get-IBConnectionInfo
        
            $uri = $ConnectionInfo.uri
            if(([system.uri]$uri).IsAbsoluteUri) {
                
                $server = ([system.net.dns]::GetHostByAddress(([system.uri]$ConnectionInfo.Uri).DnsSafeHost).HostName).Split('.')[0].ToUpper()
                # $Server = ([system.uri]$uri).host.split('.')[0].ToUpper()
            } else {
                Write-Error "$IDS_SCRIPTNAME : Connection Information URI is invalid, recreate IBConnectionInfo.xml, use Initialize-IBRestAPI"
                break
            }
        } else {
            $server = $Server.ToUpper()
        }

        Write-Output "Testing servername : $server"

        Write-Verbose "$IDS_SCRIPTNAME : Testing Server Certificate presence"
        $Store = new-object System.Security.Cryptography.X509Certificates.X509Store(
            [System.Security.Cryptography.X509Certificates.StoreName]::Root,
            "localmachine"
        )
        $Store.open("ReadOnly") 

        $ServerFound = $false
        if($store.Certificates | where { $_.subject -like "*$server*" }) { $ServerFound = $True }
        $Store.close()

        if($ServerFound) {
            Write-Output 'Server Certificate is installed'
        } else {
            Write-Output 'Server Certificate is not installed, use Import-IBServerCertificate'
        }
    } 


}
