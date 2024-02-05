function Get-IBObjectSchema
{
    Param (
        [Parameter(Mandatory=$false,Position=0)]
            [string]$ObjectType,

        [Parameter(Mandatory=$false,Position=0)]
            [switch]$GridSupportedObjects,

        [Parameter(Mandatory=$false,Position=0)]
            [switch]$GridSupportedVersions,

        [Parameter(Mandatory=$false,Position=0)]
            [ValidateSet('Standard', 'NonStandard','Complete',ignorecase=$true)]
            [string]$ShowFields
    )


    BEGIN {

        $IDS_SCRIPTNAME = 'Get-IBObjectSchema'
        Write-Verbose "$IDS_SCRIPTNAME : Retrieving the schema of the selected IB object or Grid"

    }

    PROCESS {
    }

    END {

        
        # Set the URI to retrieve the Grid object
        if (! [string]::IsNullorEmpty($ObjectType)) {
            $URI = $script:IBUriBase + '/' + $script:IBWapiVer +'/' + $ObjectType + "?_schema"
        } else {
            $URI = $script:IBUriBase + '/' + $script:IBWapiVer +'/' + "?_schema"
        }
        Write-Verbose "$IDS_SCRIPTNAME : URI = $uri"

        # Make a connection to the Grid and print the detailed error message as necessary
        try {
            $SchemaObject = Invoke-RestMethod -Uri $uri -Method Get -WebSession $script:IBSession
        } catch {
            Write-Error "[ERROR:$IDS_SCRIPTNAME] There was an error retrieving the schema."

            # Get the actual message provided by Infoblox
            $result = $_.Exception.Response.GetResponseStream()
            $reader = New-Object System.IO.StreamReader($result)
            $reader.BaseStream.Position = 0
            $reader.DiscardBufferedData()
            $responseBody = $reader.ReadToEnd()
            Write-Error "[$IDS_SCRIPTNAME] $responseBody"

            return $false
        }

        Write-Verbose "$IDS_SCRIPTNAME : $SchemaObject"
        if($ShowFields) {
            switch ($ShowFields) {
                'Standard'    { return( ($SchemaObject.Fields) | where {$_.standard_field -like  'True' } ) }
                'NonStandard' { return( ($SchemaObject.Fields) | where {$_.standard_field -like  'False' } ) }
                'Complete' { return($SchemaObject.Fields) }
                default { return ($SchemaObject.Fields) }
            }
        } else {
            if($GridSupportedVersions) {
                Return($SchemaObject.supported_versions)
            }
            if($GridSupportedObjects) {
                Return($SchemaObject.supported_objects)
            } else
            {
                return $SchemaObject
            }
        }

    }


}

