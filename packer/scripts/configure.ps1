Write-Output 'Setting Desktop timeout after closing RDS session to 15 minutes...'
Set-ItemProperty "HKLM:\SOFTWARE\Policies\Microsoft\Windows NT\Terminal Services" -Name MaxDisconnectionTime -Type 'DWord' -Value 900000
Write-Output 'Adding Az ssh extension...'
az extension add --name ssh --system
# FIX PERMISSIONS ACCESS FOR OTHER USERS
$ACL = Get-ACL -Path "$ENV:PROGRAMFILES\Windows NT"
Write-Output 'Setting az extensions path permissions...'
$ACLAZ = Get-ACL -Path "${ENV:PROGRAMFILES(x86)}\Microsoft SDKs\Azure\CLI2\"
$ACLAZ | Set-Acl -Path "${ENV:PROGRAMFILES(x86)}\Microsoft SDKs\Azure\CLI2\Lib\site-packages\azure-cli-extensions"
$ACLAZ | Set-Acl -Path "${ENV:PROGRAMFILES(x86)}\Microsoft SDKs\Azure\CLI2\Lib\site-packages\azure-cli-extensions\ssh"
Write-Output 'Configuration Complete!'
