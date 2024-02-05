function Disconnect-IBGridMaster()
{
    <#
	    .SYNOPSIS
		    Disconnects the session to the InfoBlox GridMaster.

	    .DESCRIPTION
		    Disconnects the session to the InfoBlox GridMaster.

    #>

    [CmdletBinding()]
    param ()

    $IDS_SCRIPTNAME = 'Disconnect-IBGridMaster'
    $Connected = $true

    Write-Verbose '$IDS_SCRIPTNAME : Trying to disconnect from the IB Connection Session'


    if([string]::IsNullOrEmpty($script:IBGridName) -eq $false)   { $Connected = $true }
        Write-Verbose "$IDS_SCRIPTNAME : Checked IBGridName : Connected = $connected"
    if([string]::IsNullOrEmpty($script:IBGridMaster) -eq $false) { $Connected = $true }
        Write-Verbose "$IDS_SCRIPTNAME : Checked IBGridMaster : Connected = $connected"
    if([string]::IsNullOrEmpty($script:IBGridRef) -eq $false)    { $Connected = $true }
        Write-Verbose "$IDS_SCRIPTNAME : Checked IBGridRef : Connected = $connected"
    if([string]::IsNullOrEmpty($script:IBMaxResults) -eq $false) { $Connected = $true }
        Write-Verbose "$IDS_SCRIPTNAME : Checked IBMaxResults : Connected = $connected"
    if([string]::IsNullOrEmpty($script:IBSession) -eq $false)    { $Connected = $true }
        Write-Verbose "$IDS_SCRIPTNAME : Checked IBSession : Connected = $connected"
    if([string]::IsNullOrEmpty($script:IBUriBase) -eq $false)    { $Connected = $true }
        Write-Verbose "$IDS_SCRIPTNAME : Checked IBUriBase : Connected = $connected"
    if([string]::IsNullOrEmpty($script:IBUsername) -eq $false)   { $Connected = $true }
        Write-Verbose "$IDS_SCRIPTNAME : Checked IBUsername : Connected = $connected"
    if([string]::IsNullOrEmpty($script:IBWapiVer) -eq $false)    { $Connected = $true }
        Write-Verbose "$IDS_SCRIPTNAME : Checked IBWapiVer : Connected = $connected"

    if($Connected -eq $false) {
        Write-Output "No connection present to a GridMaster"
        return
    }

    $CMD  = '/logout'

    Write-Verbose "$IDS_SCRIPTNAME : Disconnecting from IB GridMaster"    $uri = $script:IBUriBase +'/'+$script:IBWapiVer+$CMD    Write-Verbose "$IDS_SCRIPTNAME : URI - $Uri"        Try
    {
        Write-Verbose "$IDS_SCRIPTNAME : Invoke-restMethod"
        $result = Invoke-RestMethod -Method POST -Uri $uri -WebSession $script:IBSession    }
    Catch
    {
        ProcessError $IDS_SCRIPTNAME $_
        Break
    }    Write-Verbose "$IDS_SCRIPTNAME : Clearing Global variables SessionInformation"
    
    $script:IBGridName   = ''
    $script:IBGridMaster = ''
    $script:IBGridRef    = ''
    $script:IBMaxResults = ''
    $script:IBSession    = ''
    $script:IBUriBase    = ''
    $script:IBUsername   = ''
    $script:IBWapiVer    = ''

    Write-Output 'Disconnected from IB Session'
    Return($result)
}

