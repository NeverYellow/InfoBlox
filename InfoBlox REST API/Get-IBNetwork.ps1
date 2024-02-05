function Get-IBNetwork {
<#
    .Synopsis
        Invoke API commands

    .Description
        Get InfoBlox Network Record Information.

    .Outputs
        Results list

#>
    [CmdletBinding()]
    param ( 

        [parameter(Mandatory=$false, ValueFromPipeline=$true)]
        [string]$Network,

        [parameter(Mandatory=$false)]
        [string]$MaxResult


    )
    

    BEGIN {
    
        $IDS_SCRIPTNAME = 'Get-IBNetwork'
        Write-Verbose "$IDS_SCRIPTNAME : Get a list of available networks"
        
    }

    PROCESS {
    }

    END {
        
        $ConnectionInfo = Get-IBSessionVariables
        if($ConnectionInfo -eq -1) {
            $MaxResults = 1000
        } else {
            if([string]::IsNullOrEmpty($MaxResult)) {
                $MaxResults = $ConnectionInfo.IBMaxResults
            } else {
                $MaxResults = [double]$MaxResult
            }

        }

        if([string]::IsNullOrEmpty($Network)) {
            $Command = 'network'
        }else
        {
            $Command = 'network?network='+ $Network
        }


        $ConnectString = ''
        if($Command.Contains('?')) {
            $ConnectString = '&'
        }
        else {
            $ConnectString = '?'
        }
        $URIBase = $script:IBUriBase + '/' + $script:IBWapiVer + '/'+ $Command + $ConnectString + '_max_results='+$MaxResults # URI + Version + ?

                     
        Write-Verbose "$IDS_SCRIPTNAME : Invoking GET Command : $URIBase"
        
        try {
            $Result = Invoke-RestMethod -Method Get -Uri $URIBase -WebSession $Script:IBSession -ErrorAction stop
        }
        catch {
            ProcessError $IDS_SCRIPTNAME $_
            Break
        }
        return($Result)
    }

}
