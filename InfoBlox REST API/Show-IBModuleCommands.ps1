
function Show-IBModuleCommands {
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
    
        $IDS_SCRIPTNAME = 'Show-IBModuleCommands'
        Write-Verbose "$IDS_SCRIPTNAME : Showing all Module Commands"

    }

    PROCESS {
    }

    END {
        
        $ModuleName = (Get-Command $IDS_SCRIPTNAME).Module.name  # Get Modulename from Function search
        Get-Command -Module $ModuleName               # Get Commands from Module
       
        
    }

}
