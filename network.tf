
##############################################
# VIRTUAL NETWORK
##############################################
resource "azurerm_virtual_network" "vnet" {
  name                = "${var.prefix}-avd-vnet"
  resource_group_name = var.rg_name
  #  resource_group_name = azurerm_resource_group.rg.name
  location      = var.location
  address_space = ["10.10.0.0/16"]
}

##############################################
# VIRTUAL NETWORK - SUBNET
##############################################
resource "azurerm_subnet" "subnet" {
  name                = "${var.prefix}-avd-subnet"
  resource_group_name = var.rg_name
  #resource_group_name  = azurerm_resource_group.rg.name
  virtual_network_name = azurerm_virtual_network.vnet.name
  address_prefixes     = ["10.10.1.0/24"]
}

##############################################
# NETWORK SECURITY GROUP
##############################################
resource "azurerm_network_security_group" "nsg" {
  name                = "${var.prefix}-avd-nsg"
  resource_group_name = var.rg_name
  #resource_group_name = azurerm_resource_group.rg.name
  location = var.location
  security_rule {
    name                       = "DenyVnet"
    priority                   = 4095
    direction                  = "Inbound"
    access                     = "Deny"
    protocol                   = "*"
    source_port_range          = "*"
    destination_port_range     = "*"
    source_address_prefix      = "VirtualNetwork"
    destination_address_prefix = "VirutalNetwork"
  }
}

##############################################
# ROUTE TABLE
##############################################
resource "azurerm_route_table" "avdroute" {
  name                          = "rt-avd"
  location                      = var.location
  resource_group_name           = azurerm_resource_group.rg.name
  disable_bgp_route_propagation = false

  route {
    name           = "Storage"
    address_prefix = "Storage"
    next_hop_type  = "Internet"
  }

  route {
    name           = "AVD"
    address_prefix = "WindowsVirtualDesktop"
    next_hop_type  = "Internet"
  }

  route {
    name           = "AzureAD"
    address_prefix = "AzureActiveDirectory"
    next_hop_type  = "Internet"
  }

  route {
    name           = "AzureActiveDirectoryDomainServices"
    address_prefix = "AzureActiveDirectoryDomainServices"
    next_hop_type  = "Internet"
  }

  route {
    name           = "AzureCloud"
    address_prefix = "AzureCloud"
    next_hop_type  = "Internet"
  }

  lifecycle {
    ignore_changes = [tags]
  }
}

##############################################
# SUBNET & NETWORK SECURITY GROUP
##############################################
resource "azurerm_subnet_network_security_group_association" "nsg_assoc" {
  subnet_id                 = azurerm_subnet.subnet.id
  network_security_group_id = azurerm_network_security_group.nsg.id
}

##############################################
# SUBNET & NETWORK SECURITY GROUP
##############################################
resource "azurerm_subnet_route_table_association" "rt_assoc" {
  subnet_id      = azurerm_subnet.subnet.id
  route_table_id = azurerm_route_table.avdroute.id
}

/*
##############################################
# NAT GATEWAY PUBLIC IP
##############################################
resource "azurerm_public_ip" "pub_ip" {
  name                = "${var.prefix}-avd-ip"
  resource_group_name = var.rg_name
  #resource_group_name = azurerm_resource_group.rg.name
  location          = var.location
  sku               = "Standard"
  allocation_method = "Static"
  zones             = ["1"]
}

##############################################
# NAT GATEWAY PUBLIC PREFIX
##############################################
resource "azurerm_public_ip_prefix" "pub_prefix" {
  name                = "${var.prefix}-avd-pref"
  location            = var.location
  resource_group_name = var.rg_name
  #resource_group_name = azurerm_resource_group.rg.name
  prefix_length = 31
  zones         = ["1"]
}

##############################################
# NAT GATEWAY
##############################################
resource "azurerm_nat_gateway" "natgw" {
  name                = "${var.prefix}-ngw"
  location            = var.location
  resource_group_name = var.rg_name
  #resource_group_name     = azurerm_resource_group.rg.name
  sku_name                = "Standard"
  idle_timeout_in_minutes = 10
  zones                   = ["1"]
}

##############################################
# NAT GATEWAY - PUBLIC IP
##############################################
resource "azurerm_nat_gateway_public_ip_association" "ip_assoc" {
  nat_gateway_id       = azurerm_nat_gateway.natgw.id
  public_ip_address_id = azurerm_public_ip.pub_ip.id
}

##############################################
# NAT GATEWAY - IP PREFIX
##############################################
resource "azurerm_nat_gateway_public_ip_prefix_association" "pref_assoc" {
  nat_gateway_id      = azurerm_nat_gateway.natgw.id
  public_ip_prefix_id = azurerm_public_ip_prefix.pub_prefix.id
}
*/