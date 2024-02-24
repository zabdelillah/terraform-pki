terraform {
  required_providers {
    tls = {
      source = "hashicorp/tls"
      version = "4.0.5"
    }
    pkcs12 = {
      source = "chilicat/pkcs12"
      version = "0.2.5"
    }
  }
}