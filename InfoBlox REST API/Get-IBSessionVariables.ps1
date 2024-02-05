
function Get-IBSessionVariables {
<#
    .Synopsis
        Get the values that are being used by the script for the active session

    .Description
        Get values for all of the "script" local variables that are used during various connection attempts.

    .Outputs
        Simple table of values

#>
    [CmdletBinding()]
    param ( 
        [parameter(Mandatory=$false)]
        [switch]$FromConfig
    )
    

    BEGIN {
    
        $IDS_SCRIPTNAME = 'Get-IBSessionVariables'
        Write-Verbose "$IDS_SCRIPTNAME : Getting IB Toolbox Module Variables, set by Initialize-IBRestAPI"

    }

    PROCESS {
    }

    END {
        
        $connected = $true
        Write-Verbose "$IDS_SCRIPTNAME : Checking if SessionVariables are set"
        
        if([string]::IsNullOrEmpty($script:IBGridName) -eq $true)   { $Connected = $False }
        Write-Verbose "$IDS_SCRIPTNAME : Checked IBGridName : $connected"
        if([string]::IsNullOrEmpty($script:IBGridMaster) -eq $true) { $Connected = $False }
        Write-Verbose "$IDS_SCRIPTNAME : Checked IBGridMaster : $connected"
        if([string]::IsNullOrEmpty($script:IBGridRef) -eq $true)    { $Connected = $False }
        Write-Verbose "$IDS_SCRIPTNAME : Checked IBGridRef : $connected"
        if([string]::IsNullOrEmpty($script:IBMaxResults) -eq $true) { $Connected = $False }
        Write-Verbose "$IDS_SCRIPTNAME : Checked IBMaxResults : $connected"
        if([string]::IsNullOrEmpty($script:IBSession) -eq $true)    { $Connected = $False }
        Write-Verbose "$IDS_SCRIPTNAME : Checked IBSession : $connected"
        if([string]::IsNullOrEmpty($script:IBUriBase) -eq $true)    { $Connected = $False }
        Write-Verbose "$IDS_SCRIPTNAME : Checked IBUriBase : $connected"
        if([string]::IsNullOrEmpty($script:IBUsername) -eq $true)   { $Connected = $False }
        Write-Verbose "$IDS_SCRIPTNAME : Checked IBUsername : $connected"
        if([string]::IsNullOrEmpty($script:IBWapiVer) -eq $true)    { $Connected = $False }
        Write-Verbose "$IDS_SCRIPTNAME : Checked IBWapiVer : $connected"

        if($connected) {
            
            Write-Verbose "$IDS_SCRIPTNAME : All variables are set, retrieving values"

            $ConnectionInfo = "" | Select IBGridMaster, IBGridName, IBGridRef, IBMaxResults,  IBUriBase, IBUsername, IBWapiVer, IBSession
                        
            $ConnectionInfo.IBGridMaster = $script:IBGridMaster
            $ConnectionInfo.IBGridName = $script:IBGridName
            $ConnectionInfo.IBGridRef = $script:IBGridRef
            $ConnectionInfo.IBMaxResults = $script:IBMaxResults
            $ConnectionInfo.IBUriBase = $script:IBUriBase
            $ConnectionInfo.IBUsername = $script:IBUsername
            $ConnectionInfo.IBWapiVer = $script:IBWapiVer
            $ConnectionInfo.IBSession = $script:IBSession
            return($ConnectionInfo)
            
        } else {
            Write-Verbose  "$IDS_SCRIPTNAME : Variables are not set, probably not connected."
            if($FromConfig) {
                Write-Verbose "$IDS_SCRIPTNAME : Trying to load the IB Connection information from Config File"
                $ConnectionInfo = Get-IBConnectionInfo
                return($ConnectionInfo)

            }
        }


    }

}
