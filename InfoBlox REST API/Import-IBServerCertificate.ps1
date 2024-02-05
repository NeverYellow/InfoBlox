function Import-IBServerCertificate() 
{

<#
	.SYNOPSIS
		Import a Server Certificate.

	.DESCRIPTION
		Import the InfoBlox Server Certificate.

    .PARAMETER Filepath
        Fullpath and certificate name of the exported server certificate
        
    .PARAMETER ExportPassword
        The export password

	.EXAMPLE
		Import-IBServerCertificate -FilePath <server.cer> -ExportPassword <plaintext>
        
#>

[CmdletBinding()]
Param(

    [parameter(Mandatory=$true)]
    [string]$Filepath,

    [parameter(Mandatory=$true)]
    [string]$ExportPassword
   
)


    $IDS_SCRIPTNAME = 'Import-IBServerCertificate'

    $filePath = Get-DriveTruePath -FilePath $Filepath

    Write-Verbose "$IDS_SCRIPTNAME : Importing Server Certificate"
    $Certificate      = new-object System.Security.Cryptography.X509Certificates.X509Certificate2 
    $CertificatePass  = ConvertTo-SecureString -String $ExportPassword -AsPlainText -Force
    $Certificate.import($FilePath, $CertificatePass ,"Exportable,PersistKeySet") 

    $Store = new-object System.Security.Cryptography.X509Certificates.X509Store([System.Security.Cryptography.X509Certificates.StoreName]::Root,"localmachine")
    $Store.open("MaxAllowed") 
    $Store.add($Certificate) 
    $Store.close()

}
