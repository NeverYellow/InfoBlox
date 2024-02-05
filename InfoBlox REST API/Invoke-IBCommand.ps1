function Invoke-IBGetCommand {
<#
    .Synopsis
        Invoke API commands

    .Description
        Invoke specific InfoBlox commands, like network, lease and others.

    .Outputs
        Results list

#>
    [CmdletBinding()]
    param ( 

        [parameter(Mandatory=$false, ValueFromPipeline=$true)]
        [string]$Command,

        [parameter(Mandatory=$false)]
        [string]$MaxResult,

        [parameter(Mandatory=$false)]
        [switch]$NoMaxResult

    )
    

    BEGIN {
    
        $IDS_SCRIPTNAME = 'Invoke-IBCommand'
        Write-Verbose "$IDS_SCRIPTNAME : Invoking an InfoBlox REST API Command"
        
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

        if([string]::IsNullOrEmpty($Command)) {
            ProcessError $IDS_SCRIPTNAME $_
        }


        $ConnectString = ''
        if($Command.Contains('?')) {
            $ConnectString = '&'
        }
        else {
            $ConnectString = '?'
        }
        
        if($NoMaxResult -eq $false) {
            $URIBase = $script:IBUriBase + '/' + $script:IBWapiVer + '/'+ $Command + $ConnectString + '_max_results='+$MaxResults # URI + Version + ?
        } else {
            $URIBase = $script:IBUriBase + '/' + $script:IBWapiVer + '/'+ $Command #
        }


                     
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

Export-ModuleMember -Function Invoke-IBGetCommand
