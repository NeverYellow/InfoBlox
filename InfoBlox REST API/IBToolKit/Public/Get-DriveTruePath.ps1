function Get-DriveTruePath() 
{

    [CmdletBinding()]
    Param(

        [parameter(Mandatory=$true)]
        [string]$Filepath

    )

    $IDS_SCRIPTNAME = 'Get-DriveTruePath'

    Write-Verbose "$IDS_SCRIPTNAME : Retrieving the True Path of $Filepath"

    if([string]::IsNullOrEmpty($Filepath)) {
        Write-Output "$IDS_SCRIPTNAME : No path specified"
        return
    } 

    if($Filepath.Length -eq 1) {
        $Filepath+=':'
    }

    $Qualifier = Split-Path -Path $($Filepath.ToUpper()) -Qualifier
    if($Qualifier.Length -eq 2) {
        $DriveLetter = $Qualifier[0] # Get the letter
    } else {
        return($Filepath)
    }

    $NoQualifier= Split-Path -Path $Filepath -NoQualifier

    Write-Verbose "$IDS_SCRIPTNAME : Path Qualifier $Qualifier"
    Write-Verbose "$IDS_SCRIPTNAME : Path NoQualifier $NoQualifier"

    $DriveList = Get-PSDrive
    $TruePath = ($driveList.root[$drivelist.name.indexof([string]$Qualifier[0])]).TrimEnd('\')+$NoQualifier

    Return($TruePath)

}
