<#
.SYNOPSIS
Configures network settings for NIC1 on Windows Server 2019.
.DESCRIPTION
This function assigns specific IPv4 settings to NIC1 on Windows Server 2019, including IP
address, subnet mask, gateway, DNS, and disables IPv6.
.PARAMETER ThirdOctet
The desired third octet for the IP address, gateway, and DNS for NIC1.
.EXAMPLE
Set-NIC1NetworkSettings -ThirdOctet 30
.INPUTS
[int] ThirdOctet
.OUTPUTS
None
#>
function Set-NIC1NetworkSettings {
param (
[int]$ThirdOctet
)
# Validate input parameter
if (-not $ThirdOctet) {
throw "The ThirdOctet parameter is required"
}
# Ensure the subnet mask is fixed at "255.255.255.128"
$SubnetMask = "255.255.255.128"
# Formulate the full IP address, gateway, and DNS using the provided third octet
$IPAddress = "192.168.$ThirdOctet.30"
$Gateway = "192.168.$ThirdOctet.1"
$DNS = "192.168.$ThirdOctet.10"
# Disable IPv6 on NIC1
Set-NetAdapterBinding -Name "NIC1" -ComponentID ms_tcpip6 -Enabled $false
# Set IPv4 settings for NIC1
$nic1 = Get-NetAdapter -Name "NIC1"
$nic1 | Set-NetIPAddress -IPAddress $IPAddress -PrefixLength 25
$nic1 | Set-NetIPInterface -InterfaceMetric 10
$nic1 | Set-DnsClientServerAddress -ServerAddresses $DNS
# Set default gateway for NIC1
$route = New-NetRoute -DestinationPrefix "0.0.0.0/0" -InterfaceAlias "NIC1" -NextHop
$Gateway -RouteMetric 10
# Display a summary of the changes made
Write-Host "IPv4 settings for NIC1 network adapter have been set to IP Address: $IPAddress
SubnetMask: $SubnetMask Gateway: $Gateway and DNS: $DNS."
# Prompt the user to press Enter to exit
Read-Host "Press Enter to exit."
}
# Usage example
Set-NIC1NetworkSettings -ThirdOctet 30