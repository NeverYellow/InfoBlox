function Import-TMDSServerCertificate() 
{

<#
	.SYNOPSIS
		Import a Server Certificate.

	.DESCRIPTION
		Import the TM Deep Security Server Certificate.

    .PARAMETER Filepath
        Fullpath and certificate name of the exported server certificate
        
    .PARAMETER ExportPassword
        The export password

	.EXAMPLE
		Import-TMServerCertificate -FilePath .\iusec301-cert.cer -ExportPassword
        
#>

[CmdletBinding()]
Param(

    [parameter(Mandatory=$true)]
    [string]$Filepath,

    [parameter(Mandatory=$true)]
    [string]$ExportPassword
   
)

Write-Verbose 'Import-TMDSServerCertificate : Importing TM DeepSecurity Server Certificate'
$Certificate      = new-object System.Security.Cryptography.X509Certificates.X509Certificate2 
$CertificatePass  = ConvertTo-SecureString -String $ExportPassword -AsPlainText -Force
$Certificate.import($FilePath, $CertificatePass ,"Exportable,PersistKeySet") 

$Store = new-object System.Security.Cryptography.X509Certificates.X509Store(
    [System.Security.Cryptography.X509Certificates.StoreName]::Root,
    "localmachine"
)
$Store.open("MaxAllowed") 
$Store.add($Certificate) 
$Store.close()

}
