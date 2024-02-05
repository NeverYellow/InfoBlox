$gridServer  = '172.30.66.21'$initialWapiVersion = 'v1.0'

function Get-IBMaxSupportedVersion() {}

function Set-IBCertificatePolicy()
{

 add-type @"
        using System.Net;
        using System.Security.Cryptography.X509Certificates;
        public class TrustAllCertsPolicy : ICertificatePolicy {
            public bool CheckValidationResult(
                ServicePoint srvPoint, X509Certificate certificate,
                WebRequest request, int certificateProblem) {
                return true;
            }
        }
"@
    [System.Net.ServicePointManager]::CertificatePolicy = New-Object TrustAllCertsPolicy
}



(Invoke-RestMethod -Uri "https://172.30.66.21/wapi/v1.0/?_schema" -Credential $cred -Method GET).supported_versions

Invoke-RestMethod -Uri "https://172.30.66.21/wapi/v1.7.5/networkcontainer?_max_results=10" -Credential $cred -Method GET