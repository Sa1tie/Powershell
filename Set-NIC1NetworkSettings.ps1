<#
.SYNOPSIS
Configures network settings for NIC1 on Windows Server 2019.
.DESCRIPTION
This function assigns specific IPv4 settings to NIC1 on Windows Server 2019, including IP
address, subnet mask, gateway, DNS, and disables IPv6.
.PARAMETER ThirdOctet
The desired third octet of the IP address for NIC1.
.PARAMETER SubnetMask
The subnet mask for NIC1.
.PARAMETER Gateway
The gateway address for NIC1.
.PARAMETER DNS
The DNS server address for NIC1.
.EXAMPLE
Set-NIC1NetworkSettings -ThirdOctet 30 -SubnetMask "255.255.255.128" -Gateway
"192.168.X.1" -DNS "192.168.x.10"
.INPUTS
[int] ThirdOctet
[string] SubnetMask
[string] Gateway
[string] DNS
.OUTPUTS
None
#>
function Set-NIC1NetworkSettings {
param (
[int]$ThirdOctet,
[string]$SubnetMask,
[string]$Gateway,
[string]$DNS
)
# Validate input parameters
if (-not $ThirdOctet -or -not $SubnetMask -or -not $Gateway -or -not $DNS) {
throw "All parameters are required"
}
# Create the full IP address based on the provided third octet
$IPAddress = "192.168.$ThirdOctet.30"
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
}

# Usage example: Change the ThirdOctet to customize the IP address
Set-NIC1NetworkSettings -ThirdOctet 50 -SubnetMask "255.255.255.128" -Gateway
"192.168.X.1" -DNS "192.168.x.10"


