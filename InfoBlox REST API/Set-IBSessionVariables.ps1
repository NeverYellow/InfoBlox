
function Set-IBSessionVariables {
<#
    .Synopsis
        Show the values that are being used by the script for the active session

    .Description
        Show values for all of the "script" local variables that are used during various connection attempts.

    .Outputs
        Simple table of values

#>
    [CmdletBinding()]
    param ( 

        [parameter(Mandatory=$false)]
        [string]$IBMaxResults,

        [parameter(Mandatory=$false)]
        [string]$IBWAPIVersion
    )
    

    BEGIN {
    
        $IDS_SCRIPTNAME = 'Set-IBSessionVariables'
        Write-Verbose "$IDS_SCRIPTNAME : Setting IB Toolbox Module Variables"

    }

    PROCESS {
    }

    END {
        
        if([string]::IsNullOrEmpty($IBMaxResults)) { $script:IBMaxResults = $script:IBMaxResults } else { $script:IBMaxResults = $IBMaxResults }
        if([string]::IsNullOrEmpty($IBWAPIVersion)) {  $script:IBWapiVer = $script:IBWapiVer } else {  $script:IBWapiVer = $IBWAPIVersion }

        Write-Host "Grid Master : '$script:IBGridMaster'"
        Write-Host "Grid Name   : '$script:IBGridName'"
        Write-Host "Grid Ref    : '$script:IBGridRef'"
        Write-Host "Max Results : '$script:IBMaxResults'"
        Write-Host "URI Base    : '$script:IBUriBase'"
        Write-Host "Username    : '$script:IBUsername'"
        Write-Host "WAPI Version: '$script:IBWapiVer'"

    }

}
