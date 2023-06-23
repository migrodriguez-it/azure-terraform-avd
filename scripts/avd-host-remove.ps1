param (
    $ErrorActionPreference = "Stop",

    [Parameter(Mandatory = $true)][string]$HostPoolName,
    [Parameter(Mandatory = $true)][string]$Name,
    [Parameter(Mandatory = $true)][string]$ResourceGroupName
)

$subscriptionId = ""
$tenantId = ""
$clientId = ""
$secret = ""

$securesecret = ConvertTo-SecureString -String $secret -AsPlainText -Force
$Credential = New-Object pscredential($clientId,$securesecret)
Connect-AzAccount -Credential $Credential -Tenant $tenantId -ServicePrincipal
Select-AzSubscription $subscriptionId

#####

$ProgressPreference = "SilentlyContinue"
Install-Module Az.DesktopVirtualization
Import-Module Microsoft.PowerShell.Utility
Import-Module Az.DesktopVirtualization

Remove-AzWvdSessionHost -HostPoolName $HostPoolName -Name $Name -ResourceGroupName $ResourceGroupName