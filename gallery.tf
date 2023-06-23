##############################################
# SHARED IMAGES GALLERY
##############################################
resource "azurerm_shared_image_gallery" "sig" {
  name                = "${var.prefix}SIG"
  resource_group_name = var.rg_name
  #resource_group_name = azurerm_resource_group.rg.name
  location = var.location
}

##############################################
# IMAGES DEFINITION
##############################################
resource "azurerm_shared_image" "imgdef" {
  name                = "${var.prefix}-imgdef"
  gallery_name        = azurerm_shared_image_gallery.sig.name
  resource_group_name = var.rg_name
  #resource_group_name = azurerm_resource_group.rg.name
  location           = var.location
  os_type            = var.vm_os-type
  hyper_v_generation = "V2"

  identifier {
    publisher = var.vm_publisher
    offer     = var.vm_offer
    sku       = var.vm_sku
  }
}