Function Get-IBModuleVersion()
{
    <#
	    .SYNOPSIS
		    Shows the version of the IB Powershell Module

	    .DESCRIPTION
		    Returns the version information of the IB Tools Powershell Module

        .EXAMPLE
		    Get-IBModuleVersion
            returns the version information

    #>

    [CmdletBinding()]
    Param()

    # default definitions
    $IDS_SCRIPTNAME = 'Get-IBModuleVersion'
        $ModuleName = (Get-Command $IDS_SCRIPTNAME).Module.name  # Get Modulename from Function search
    $ModuleInfo = Get-Module -Name $ModuleName               # Get Module information from Module Manifest

    $ThisModuleInfo = "" | Select Name, Description, Version, ModuleType, Author, Company, Copyright, ModuleBase, PowerShellversion

    $ThisModuleInfo.name              = $ModuleInfo.name
    $ThisModuleInfo.Description       = $ModuleInfo.Description
    $ThisModuleInfo.Version           = $ModuleInfo.Version
    $ThisModuleInfo.ModuleType        = $ModuleInfo.ModuleType
    $ThisModuleInfo.Author            = $ModuleInfo.Author
    $ThisModuleInfo.Company           = $ModuleInfo.Company
    $ThisModuleInfo.Copyright         = $ModuleInfo.Copyright
    $ThisModuleInfo.ModuleBase        = $ModuleInfo.ModuleBase
    $ThisModuleInfo.PowerShellversion = $ModuleInfo.PowerShellversion

    return($ThisModuleInfo)

}