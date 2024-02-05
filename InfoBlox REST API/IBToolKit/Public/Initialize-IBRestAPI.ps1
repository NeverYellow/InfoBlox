function Initialize-IBRestAPI()
{
    <#
	    .SYNOPSIS
		    Initialize REST API Connection settings

	    .DESCRIPTION
		    Initializes the Connection setting for connecting to the REST API of an InfoBlox Grid Server

        .PARAMETER Uri
            Uri to the server

        .PARAMETER Username
            Username of the account with which you want to make a connection

        .PARAMETER Password
            Password of the account with which you want to make a connection

	    .EXAMPLE
		    Initialize-IBRestAPI -Uri 'https://10.0.0.10/wapi' -Username APIuser -Password WhateverPassword!

	    .EXAMPLE
		    If you have forgotten which settings you used, use :
            Get-IBSessionVariables -FromConfig | Initialize-IBRestAPI -Password WhateverPassword!
    #>

    [CmdletBinding()]
    Param(

        [parameter(Mandatory=$true, ValueFromPipelineByPropertyName=$true)]
        [string]$Uri,

        [parameter(Mandatory=$true, ValueFromPipelineByPropertyName=$true)]
        [string]$Username,

        [parameter(Mandatory=$true)]
        [string]$PlainPassword

   
    )

    Begin {
        Write-Verbose "Just for fun!"
    }

    Process {
        $RESTAPIConnectionInfo = "" | Select Uri, Username, SecurePassword, APIVersion
        $RESTAPIConnectionInfo.Uri      = $Uri
        $RESTAPIConnectionInfo.Username = $Username
    
        $SecurePassword = $PlainPassword  | ConvertTo-SecureString -AsPlainText -Force
        $SecureString   = $SecurePassword | ConvertFrom-SecureString

        $RESTAPIConnectionInfo.SecurePassword = $SecureString

        $Password = $SecureString | ConvertTo-SecureString 
        $Credential = New-Object System.Management.Automation.PSCredential $Username,$Password 

        $SupportedVersions = (Invoke-RestMethod -Uri "$uri/v1.0/?_schema" -Credential $Credential -Method GET).supported_versions
        $HighestVersion = $SupportedVersions[$SupportedVersions.count-1]
    
        $RESTAPIConnectionInfo.APIVersion = 'v'+$HighestVersion

        Write-Verbose "Initialize-IBRestAPI : Exporting Account settings to XML file"
        Export-Clixml -Path $PSScriptRoot\..\Data\IBConnection.xml -InputObject $RESTAPIConnectionInfo -Confirm:$false 

    }

    End {
        Write-Verbose "End of Fun!"
        Return($RESTAPIConnectionInfo)
    }

}