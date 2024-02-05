# $psISE.CurrentFile.Editor.ToggleOutliningExpansion()

function Get-IBNetworkExtAttrs {
<#
    .Synopsis
        Get the extensible attributes of the requested Network

    .Description
        Get the extensible attributes of the requested Network

    .Outputs
        Network Extensible Attributes information

    .Example
        Get-IBNetworkExtAttrs -Network 10.10.0.10
        Get-IBNetworkExtAttrs 10.0.10.0


#>
    [CmdletBinding()]
    param ( 

        [parameter(Mandatory=$false, ValueFromPipelineByPropertyName=$true)]
        [psobject[]]$Network,

        [parameter(Mandatory=$false)]
        [string]$MaxResult


    )
    

    #region Initialization Code
    BEGIN {
        
        $networkInfo = @()

        $IDS_SCRIPTNAME = 'Get-IBNetworkExtAttrs'
        Write-Verbose "$IDS_SCRIPTNAME : Get the extensible attributes of the requested Network"

        if ($PSCmdlet.MyInvocation.ExpectingInput) {
            Write-Verbose "Data received from pipeline input: '$($Network)'"
        }
 
        else {
            Write-Verbose "Data received from parameter input: '$($Network)'"
        }

        
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

        
    }
    #endregion End Initialization Code

    #region Begin Process
    PROCESS {
        
        Write-Verbose "Pipe   : $network"

        if([string]::IsNullOrEmpty($Network)) {
            $FormatError = New-Object System.FormatException "No Network address specified"
            Throw $FormatError            
            ProcessError $IDS_SCRIPTNAME $_
        }

        $Command = 'network?_return_fields=extattrs&network='+ $Network
        
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
        $networkInfo += $Result

    }
    #endregion End Process

    END {
        
        
        return($networkInfo)
    }

}
