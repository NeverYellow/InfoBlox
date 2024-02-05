function Get-IBIPAddress {
<#
    .Synopsis
        Get Additional Information of the requested IPAddress

    .Description
        Get Additional Information of the requested IPAddress

    .Outputs
        IP Address record information

    .Example
        Get-IBIPAddress -IPAddress 10.10.0.10
        Get-IBIPAddress 10.0.10.0

    .Example
        Get-IBIPAddress -UseHostIP


#>
    [CmdletBinding()]
    param ( 

        [parameter(Mandatory=$false,ValueFromPipelineByPropertyName=$true, ParameterSetName='IPDefined')]
        [Alias('ipv4addr')]
        [string]$IPAddress,

        [parameter(Mandatory=$false,ValueFromPipelineByPropertyName=$true,ParameterSetName='IPNetwork')]
        [Alias('network')]
        [string]$Range,

        [parameter(Mandatory=$false, ParameterSetName='IPHost')]
        [switch]$UseHostIP,

        [parameter(Mandatory=$false)]
        [string]$MaxResult


    )
    

    BEGIN {
    
        $IDS_SCRIPTNAME = 'Get-IBIPAddress'
        Write-Verbose "$IDS_SCRIPTNAME : Get Additional Information of the requested IPAddress"
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
        if($UseHostIP) { 
             $IPAddress = Get-CimInstance -ClassName Win32_NetworkAdapterConfiguration | where {$_.IPEnabled -eq $true } | select -ExpandProperty IPAddress | where { $_ -notlike '*:*'}  # IPv4
            # $IPAddress = (Get-CimInstance -ClassName Win32_NetworkAdapterConfiguration | ? { $_.IPAddress -ne $null }).IPAddress
        }        

        
        if(![string]::IsNullOrEmpty($Range)) {
            Write-Host "Network range : $Range"

            $IBnetmask             = $range.split('/')[1]
            $IBnetwork             = $range.split('/')[0]
            if([string]::IsNullOrEmpty($IBnetmask)) {
                $IBRequest = Get-IBNetWork -Network $IBnetwork
                $range = $IBRequest.network
                $IBnetmask             = $range.split('/')[1]
                $IBnetwork             = $range.split('/')[0]
            }
            $numberOfIPAddresses =  [math]::Pow(2,(32 - $IBNetmask))
            $usableAddresses = $numberOfIPAddresses-2
            $DHCPRangeInfo = invoke-ibcommand -Command "range?network=$range"   # Informatie specifieke network
            Write-Host "Network / Range : $Range - $numberOfIPAddresses addresses (usable $usableAddresses), Start-Address : $($DHCPRangeInfo.start_addr) - End Address : $($DHCPRangeInfo.end_addr)"


        } else {
            if([string]::IsNullOrEmpty($IPAddress)) {
                $FormatError = New-Object System.FormatException "EmptyRecord"
                Throw $FormatError            
                ProcessError $IDS_SCRIPTNAME $_
            }
            $Command = ''
            $Command += 'ipv4address?ip_address='+ $IPAddress
        
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

    END {


    }

}
