Function Connect-IBGridMaster()
{
    <#
	    .SYNOPSIS
		    Connect to the REST API of an InfoBlox GridMaster.

	    .DESCRIPTION
		    Connects to the InfoBlox GridMaster and returns some info

	    .PARAMETER SkipCertificateCheck
		    Does not come with the message that there is no Server certificate installed, 
            but sets the TrustAllCertsPolicy. (not secure)
	    
        .EXAMPLE
		    Connect-IBGridMaster -ShowSessionID
            returns the SessionID (puts it in a Global variable : IBSessionID)

            Connect-IBGridMaster -SkipCertificateCheck
            Connect even if it has no server certificate (less secure)

    #>

    [CmdletBinding()]
    param ( 

        [parameter(Mandatory=$false)]
        [switch]$SkipCertificateCheck


    )

    Write-Verbose "$IDS_SCRIPTNAME : Trying to load the IB Connection information"
    $ConnectionInfo = Get-IBConnectionInfo

    $script:IBGridName   = $null
    $script:IBGridMaster = $null
    $script:IBGridRef    = $null
    $script:IBMaxResults = $null
    $script:IBSession    = $null
    $script:IBUriBase    = $null
    $script:IBUsername   = $null
    $script:IBWapiVer    = $null

    
    if ([string]::IsNullOrEmpty($IBSessionID) -eq $false) { # False means IBSessionID exists
        Write-Verbose '$IDS_SCRIPTNAME : Session ID Already Exists. Reusing SessionID'
        if($ShowSessionID) {
            return($IBSessionID)
        }
    }
    $IBAPIServer  = $ConnectionInfo.Uri
    $IBAPIVersion = $ConnectionInfo.APIVersion
    $IDS_SCRIPTNAME = 'Connect-IBGridMaster'

    $loginCMD  = '/grid'

    Write-Verbose "$IDS_SCRIPTNAME : Connecting with Invoke-RestMethod to IB GridMaster"
    $uri = $IBAPIServer+'/'+$IBAPIVersion+$loginCMD
    Write-Verbose "$IDS_SCRIPTNAME : URI - $Uri"
    
    Try
    {
        Write-Verbose "$IDS_SCRIPTNAME : Building Credential String"
            
        $Password = $($ConnectionInfo.SecurePassword) | ConvertTo-SecureString -ErrorAction Stop

        $username = $ConnectionInfo.Username
        $Credential = New-Object System.Management.Automation.PSCredential $username,$Password 

        if($Force) {
            Write-Verbose "$IDS_SCRIPTNAME : Forcing connection, setting TrustAllCertsPolicy"
            Set-IBTrustAllCertsPolicy
        }

        Write-Verbose "$IDS_SCRIPTNAME : Invoke-restMethod"
        $GridObj = Invoke-RestMethod -Method GET -Uri $uri -Credential $Credential -SessionVariable SessionInfo
    }
    Catch
    {
        ProcessError $IDS_SCRIPTNAME $_
        Break
    }

    # Get the name of the Grid
    $StrIndex = $GridObj._ref.IndexOf(":")
    $IB_GridName = $GridObj._ref.Substring( $( $StrIndex + 1 ) )


    $script:IBGridName   = $IB_GridName
    $script:IBGridMaster = ([System.Uri]$ConnectionInfo.Uri).Host
    $script:IBGridRef    = $GridObj._ref
    $script:IBMaxResults = 1000
    $script:IBSession    = $SessionInfo
    $script:IBUriBase    = ([System.Uri]$ConnectionInfo.Uri).AbsoluteUri
    $script:IBUsername   = $ConnectionInfo.username
    $script:IBWapiVer    = $ConnectionInfo.APIVersion

    Write-Verbose "$IDS_SCRIPTNAME : Setting Global variables SessionInformation"
    
    # Set-Variable -Name IBSessionID -Value $sID -Scope Global

    Return($GridObj)
}