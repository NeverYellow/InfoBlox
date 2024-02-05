Param(

  [Parameter(Position=0, Mandatory=$True, ValueFromPipeline=$True)]
  [string]$userName,
  
  [Parameter(Position=1, Mandatory=$True, ValueFromPipeline=$True, ParameterSetName='EnableUser')]
  [string]$password,

  [Parameter(ParameterSetName='EnableUser')]
  [switch]$enable,

  [Parameter(ParameterSetName='DisableUser')]
  [switch]$disable,
  [string]$computerName = $env:ComputerName,
  [string]$description = "modified via powershell"

 )
