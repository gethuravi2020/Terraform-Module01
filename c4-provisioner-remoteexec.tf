resource "null_resource" "iis" {
  # Provision IIS on the Windows VM
  provisioner "remote-exec" {
    inline = [
      "powershell -Command Install-WindowsFeature -Name Web-Server",
      //"powershell -Command net start w3svc"
    ]
    connection {
      type     = "winrm"
      user     = "adminuser"
      password = "P@$$w0rd1234!"
      host     = azurerm_windows_virtual_machine.example.public_ip_address
      port     = 5985
      https    = false
      timeout  = "3m"
    }
  }

  depends_on = [azurerm_windows_virtual_machine.example]
}

resource "null_resource" "example" {
  provisioner "file" {
    source      = "C:\\index.html"
    destination = "C:\\inetpub\\wwwroot\\index.html"
    connection {
      type     = "winrm"
      user     = "adminuser"
      password = "P@$$w0rd1234!"
      host     = azurerm_windows_virtual_machine.example.public_ip_address
      port     = 5985
      https    = false
      timeout  = "3m"
    }
  }
  depends_on = [null_resource.iis]
}


