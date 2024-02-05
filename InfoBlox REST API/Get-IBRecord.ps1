function Get-IBRecord {
<#
    .Synopsis
        Invoke API commands

    .Description
        Get InfoBlox Object Record Information.

    .Outputs
        Results list

#>
    [CmdletBinding()]
    param ( 

        [parameter(Mandatory=$false, ValueFromPipeline=$true, ValueFromPipelineByPropertyName=$true)]
        [Alias('names')]
        [string]$Record,

        [Parameter(Mandatory=$false)]
        [ValidateSet('A', 'AAAA','CNAME','HOST','NAPTR','PTR','SRV','TXT','MX',ignorecase=$true)]
        [string]$Type,
        
        [parameter(Mandatory=$false)]
        [string]$IPInformation,

        [parameter(Mandatory=$false)]
        [string]$MaxResult


    )
    

    BEGIN {
    
        $IDS_SCRIPTNAME = 'Get-IBRecord'
        Write-Verbose "$IDS_SCRIPTNAME : Invoking an InfoBlox REST API Resource Record command"
       
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

    PROCESS {        
    
        if([string]::IsNullOrEmpty($Record)) {
            $FormatError = New-Object System.FormatException "EmptyRecord"
            Throw $FormatError            
            ProcessError $IDS_SCRIPTNAME $_
        }

        if([string]::IsNullOrEmpty($type)) {
            $type = 'host' #Default value is : host
        }
        switch ($type) {
            'A'     { $Command = 'record:a' }
            'AAAA'  { $Command = 'record:aaaa' }
            'CNAME' { $Command = 'record:cname' }
            'HOST'  { $Command = 'record:host' }
            'NAPTR' { $Command = 'record:naptr' }
            'PTR'   { $Command = 'record:ptr' }
            'SRV'   { $Command = 'record:srv' }
            'TXT'   { $Command = 'record:txt' }
            'MX'    { $Command = 'record:mx' }
            default { $Command = 'record:host' }
        }

        $Command += '?name~='+ $Record
        
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

    END {

    }

}
