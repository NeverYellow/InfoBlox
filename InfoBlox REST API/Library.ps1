
function Get-CurrentPath(){

    <#
	.SYNOPSIS
		Returns the CurrentPath

	.DESCRIPTION
		Retrieves the working location of the Script via the MyInvocation variable

	.EXAMPLE
		$CurrentPath = Get-CurrentPath
        returns the CurrentPath

    #>

    $PathInfo = $script:MyInvocation.MyCommand.Path
    $CurrentPath = Split-Path $PathInfo
    Return($CurrentPath)

}

function Get-IBConnectionInfo() {
    
     <#
	.SYNOPSIS
		Returns the saved Connection Information

	.DESCRIPTION
		Retrieves the saved Connection Information with Username / Password

	.EXAMPLE
		$ConnectionInfo = Get-IBConnectionInfo
        Returns the Account/Connection information as an object

    #>
    [CmdletBinding()]
    Param()
    
    $FileToImport = $PSScriptRoot + '\..\Data\IBConnection.xml'
    # Write-Output "Path to : $FileToImport"
    If((Test-Path $FileToImport) -eq $true) {
        Write-Verbose "Get-IBConnectionInfo : Importing XML File : $FileToImport"
        $ConnectionInfo = Import-Clixml -Path $FileToImport
    } else { 
        Write-Error 'No IBConnection file found. Use Initialize-IBRestAPI'    
        break
    }
    return($ConnectionInfo)
}
Export-modulemember -function Get-IBConnectionInfo

function ProcessError() 
{

    [CmdletBinding()]
    Param(
        [String]$IDS_ORIGINATING_SCRIPTNAME,
        [array]$ErrorArray
    )
    $IDS_SCRIPTNAME = 'ProcessError'

    $ErrorMessage          = $ErrorArray.Exception.Message
    $FailedItem            = $ErrorArray.Exception.ItemName
    $Status                = $ErrorArray.Exception.Status
    $FullyQualifiedErrorId = $ErrorArray.FullyQualifiedErrorId

    Write-Verbose "$IDS_SCRIPTNAME : ($IDS_ORIGINATING_SCRIPTNAME) : ErrMsg     : $ErrorMessage"
    Write-Verbose "$IDS_SCRIPTNAME : ($IDS_ORIGINATING_SCRIPTNAME) : FailedItem : $FailedItem"
    Write-Verbose "$IDS_SCRIPTNAME : ($IDS_ORIGINATING_SCRIPTNAME) : Status     : $Status"
    Write-Verbose "$IDS_SCRIPTNAME : ($IDS_ORIGINATING_SCRIPTNAME) : FullyQualifiedErrorId : $FullyQualifiedErrorId"
    
    $ErrorNum = '001' # Undefined error
    if($ErrorMessage -like '*(400)*') { $ErrorNum = '400' } 
    if($ErrorMessage -like '*(403)*') { $ErrorNum = '403' } 
    if($ErrorMessage -like '*(500)*') { $ErrorNum = '500' } 
    if($ErrorMessage -like '*trust relationship for the SSL*') { $ErrorNum = '002' }
    # if($ErrorMessage -like '*Sleutel is niet geldig*') { $ErrorNum = '003' }
    if($FullyQualifiedErrorId -like '*ImportSecureString_InvalidArgument_CryptographicError*') { $ErrorNum = '003' }
    if($ErrorMessage -Like '*Invalid URI:*') { $ErrorNum = '004' }
    if($ErrorMessage -Like '*EmptyCommand*') { $ErrorNum = '005' }
    if($ErrorMessage -Like '*EmptyRecord*') { $ErrorNum = '006' }
          
    switch($ErrorNum) {
        '001' { Write-Output "$IDS_ORIGINATING_SCRIPTNAME : A not yet defined error occured, ErrorMessage : $ErrorMessage"}
        '002' { Write-Output "$IDS_ORIGINATING_SCRIPTNAME : $ErrorMessage, Use Import-IBSServerCertificate for importing the Server Certificate `nor use Set-IBTrustAllCertsPolicy`nYou can also use the parameter -SkipCertificateCheck"}
        '003' { Write-Output "$IDS_ORIGINATING_SCRIPTNAME : Encrypted string not valid anymore, maybe it was created in another session, use Initialize-IBRestAPI`nIf you are reconnecting use : Get-IBSessionVariables -FromConfig | Initialize-IBRestAPI"}
        '004' { Write-Output "$IDS_ORIGINATING_SCRIPTNAME : Invalid URI: Most likely there is no connection to the GridMaster or it is not yet configured."}
        '005' { Write-Output "$IDS_ORIGINATING_SCRIPTNAME : No command specified. Please enter a command, for a list of objects use Get-IBObjectSchema -GridSupportedObjects"}
        '006' { Write-Output "$IDS_ORIGINATING_SCRIPTNAME : No record specified. Please use a resource type like A, AAAA, CNAME, MX, PTR or some other resource type"}
        '400' { Write-Output "$IDS_ORIGINATING_SCRIPTNAME : Bad Request, Request is most likely not complete, Use Get-Help $IDS_ORIGINATING_SCRIPTNAME -Examples or try with -Verbose parameter"}
        '403' { Write-Output "$IDS_ORIGINATING_SCRIPTNAME : SessionID not valid anymore, Timed out or some other reason, `nPlease use Connect-IBGridMaster to make a connection"}
        '500' { Write-Output "$IDS_ORIGINATING_SCRIPTNAME : Server Error or Internal Error, Try again or check Infoblox GridMaster"}
    }
    # Extended Error Info

    Switch($ErrorNum) {
        '400' { 
            Get-IBRealError $IDS_ORIGINATING_SCRIPTNAME $ErrorArray
            }
       
    }

    return
}

function Test-DateTime()
{

    param (
   
        [string]$TestDate = (Get-Date).tostring(),

        [ValidateSet("From","To")]
        [string]$FromTo,

        [switch]$LongFormat = $false
        
    )

    $date = $TestDate -as [datetime]

    switch($FromTo) {
        'From'  { $Time = '00:00' } 
        'To'    { $Time = '23:59' }
        default { $Time = '00:00' }
    }

    if($LongFormat) {
        $PassedDate = "{0:dd MMM yyyy $time}"-f $date
    } else {
        $PassedDate = "{0:yyyyMMdd $time}" -f $date
    }

    Return($PassedDate)

}


function Get-IBRealError()
{

    [CmdletBinding()]
    Param(
        [String]$IDS_ORIGINATING_SCRIPTNAME,
        [array]$ErrorArray
    )
    $IDS_SCRIPTNAME = 'Get-IBRealError'

    $result = $ErrorArray.Exception.Response.GetResponseStream()
    $reader = New-Object System.IO.StreamReader($result)
    $reader.BaseStream.Position = 0
    $reader.DiscardBufferedData()
    $responseBody = $reader.ReadToEnd()

    Write-Output "$IDS_SCRIPTNAME : ($IDS_ORIGINATING_SCRIPTNAME) : $responseBody"

}