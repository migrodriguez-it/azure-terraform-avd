Set-ExecutionPolicy Bypass -Scope Process -Force
[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12
iex ((New-Object System.Net.WebClient).DownloadString('https://chocolatey.org/install.ps1'))
choco install fslogix -y --force --force-dependencies
choco install putty.install -y --force --force-dependencies
choco install vscode -y --force --force-dependencies
choco install openvpn -y --force --force-dependencies
choco install amazon-workspaces -y --force --force-dependencies
choco install azure-data-studio-sql-server-admin-pack -y --force --force-dependencies
choco install azure-cli -y --force --force-dependencies
choco install awscli -y --force --force-dependencies
choco install git -y --force --force-dependencies
choco install microsoftazurestorageexplorer -y --force --force-dependencies
choco install notepadplusplus -y --force --force-dependencies
choco install wireguard -y --force --force-dependencies
choco install sql-server-management-studio -y --force --force-dependencies
choco install powershell-core -y --force --force-dependencies
choco install peazip -y --force --force-dependencies
choco install mobaxterm -y --force --force-dependencies
choco install wireshark -y --force --force-dependencies
choco install javaruntime -y --force --force-dependencies
choco install python -y --force --force-dependencies
choco install gh -y --force --force-dependencies
choco install packer -y --force --force-dependencies
choco install terraform -y --force --force-dependencies
choco install drawio -y --force --force-dependencies
choco install remote-desktop-client -y --force --force-dependencies
choco install firefox -y --force --force-dependencies
choco install chocolateygui -y --force --force-dependencies
choco install winscp -y --force --force-dependencies
choco install wsl -y -d Debian -y --force --force-dependencies
choco install azcopy -y --force --force-dependencies