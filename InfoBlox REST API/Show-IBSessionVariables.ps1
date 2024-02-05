
function Show-IBSessionVariables {
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
        [switch]$ShowAllVariables

    )
    

    BEGIN {
    
        $IDS_SCRIPTNAME = 'Show-IBSessionVariables'
        Write-Verbose "$IDS_SCRIPTNAME : Getting IB Toolbox Module Variables"

    }

    PROCESS {
    }

    END {
        
        Write-Host "Grid Master : '$script:IBGridMaster'"
        Write-Host "Grid Name   : '$script:IBGridName'"
        Write-Host "Grid Ref    : '$script:IBGridRef'"
        Write-Host "Max Results : '$script:IBMaxResults'"
        Write-Host "URI Base    : '$script:IBUriBase'"
        Write-Host "Username    : '$script:IBUsername'"
        Write-Host "WAPI Version: '$script:IBWapiVer'"

        if($ShowAllVariables) {
            $Scriptvars = Get-Variable -Scope Script
            return($Scriptvars)
        }
    }

}
