function Test-TMDSServerCertificate() 
{

<#
	.SYNOPSIS
		Test presence of a server Certificate.

	.DESCRIPTION
		Test if the the TM Deep Security Server Certificate is present in the Root / Local store

    .PARAMETER Server
        TM DeepSecurity Server name to test
        
	.EXAMPLE
		Test-TMServerCertificate -Server
        
#>

    [CmdletBinding()]
    Param(

        [string]$Server
       
    )

    if([string]::IsNullOrEmpty($Server) -eq $true) { # Server name is an empty string
        $ConnectionInfo = Get-TMDSConnectionInfo
        $uri = $ConnectionInfo.uri
        if(([system.uri]$uri).IsAbsoluteUri) {
            $Server = ([system.uri]$uri).host.split('.')[0].ToUpper()
        } else {
            Write-Error 'Test-TMDSServerCertificate : Connection Information URI is invalid, recreate TMDSConnectionInfo.xml, use Initialize-TMDSRestAPI'
            break
        }
    } else {
        $server = $Server.ToUpper()
    }


    Write-Verbose 'Test-TMDSServerCertificate : Testing TM DeepSecurity Server Certificate presence'
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
        Write-Output 'Server Certificate is not installed, use Import-TMDSServerCertificate'
    }
 


}
