# Start by logging into your Azure account
Login-AzureRmAccount

# This creates a new resource group but I don't want a new resource group.
# All subsequent commands need to be aimed at the resource group: CincoCorporation
# New-AzureRmResourceGroup -Name CincoCorporation -Location "North Central US"

# Create a subnet configuration
$subnetConfig = New-AzureRmVirtualNetworkSubnetConfig -Name CincoCorporationSubnet -AddressPrefix 10.0.90.0/24

# Create a virtual network
$vnet = New-AzureRmVirtualNetwork -ResourceGroupName CincoCorporation -Location "North Central US" -Name CincoAzureVNet -AddressPrefix 10.0.0.0/16 -Subnet $subnetConfig

# Create a public IP address and specify a DNS name
$pip = New-AzureRmPublicIpAddress -ResourceGroupName CincoCorporation -Location "North Central US" -AllocationMethod Static -IdleTimeoutInMinutes 4 -Name "thevmname0"

# Create an inbound network security group rule for port 22
$nsgRuleSSH = New-AzureRmNetworkSecurityRuleConfig -Name thevmname0-ssh-sec-rule -Protocol Tcp -Direction Inbound -Priority 1000 -SourceAddressPrefix * -SourcePortRange * -DestinationAddressPrefix * -DestinationPortRange 22 -Access Allow

# Create an inbound network security group rule for port 80
$nsgRuleWeb = New-AzureRmNetworkSecurityRuleConfig -Name thevmname0-www-sec-rule -Protocol Tcp -Direction Inbound -Priority 1001 -SourceAddressPrefix * -SourcePortRange * -DestinationAddressPrefix * -DestinationPortRange 80 -Access Allow

# Create a network security group
$nsg = New-AzureRmNetworkSecurityGroup -ResourceGroupName CincoCorporation -Location "North Central US" -Name CincoSecurityGroup -SecurityRules $nsgRuleSSH,$nsgRuleWeb

# ++++++++++++++++++++++++++++++++++++

# Create a virtual network card and associate with public IP address and NSG
$nic = New-AzureRmNetworkInterface -Name thevmname0-nic-00 -ResourceGroupName CincoCorporation -Location "North Central US" -SubnetId $vnet.Subnets[0].Id -PublicIpAddressId $pip.Id -NetworkSecurityGroupId $nsg.Id

# Define a credential object
$securePassword = ConvertTo-SecureString 'thepassword' -AsPlainText -Force
$cred = New-Object System.Management.Automation.PSCredential ("theusername", $securePassword)

# Create a virtual machine configuration
$vmConfig = New-AzureRmVMConfig -VMName thevmname0 -VMSize Standard_D1 | Set-AzureRmVMOperatingSystem -Linux -ComputerName thevmname0 -Credential $cred -DisablePasswordAuthentication | Set-AzureRmVMSourceImage -PublisherName Canonical -Offer UbuntuServer -Skus 14.04.2-LTS -Version latest | Add-AzureRmVMNetworkInterface -Id $nic.Id

# Configure SSH Keys
$sshPublicKey = Get-Content "$env:USERPROFILE\Desktop\pathtopublickey\id_rsa.pub" -Raw
Add-AzureRmVMSshPublicKey -VM $vmconfig -KeyData $sshPublicKey -Path "/home/theusername/.ssh/authorized_keys"

# ++++++++++++++++++++++++++++++++++++

New-AzureRmVM -ResourceGroupName CincoCorporation -Location "North Central US" -VM $vmConfig
