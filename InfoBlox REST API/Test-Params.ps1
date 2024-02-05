[CmdletBinding()]
param ( 

    [parameter(Mandatory=$false)]
    [ValidateSet('ClusterName','ESXHostNr','VmGroupName','HostGroupName','VMname','RuleName','ESXHost','Storage','StorageNr')][array]$Column,

    [parameter(Mandatory=$false)]
    [ValidateSet('VMHostAffinity','VMAntiAffinity','VMAffinity')][array]$AffinityType


)

Write-Host "$column"
