variable "ca_country" {
  type = string
  description = ""
}
variable "ca_province" {
  type = string
  description = ""
}
variable "ca_locality" {
  type = string
  description = ""
}
variable "ca_cn" {
  type = string
  description = ""
}
variable "ca_org" {
  type = string
  description = ""
}
variable "ca_org_name" {
  type = string
  description = ""
}
variable "ca_validity" {
  type = number
  default = 43800
}

/**
 * Private key for use by the self-signed certificate, used for
 * future generation of child certificates
 */
resource "tls_private_key" "pem_ca" {
  algorithm = var.algorithm
}

resource "tls_self_signed_cert" "ca" {
  private_key_pem = tls_private_key.pem_ca.private_key_pem
  is_ca_certificate = true

  subject {
    country             = var.ca_country
    province            = var.ca_province
    locality            = var.ca_locality
    common_name         = var.ca_cn
    organization        = var.ca_org
    organizational_unit = var.ca_org_name
  }

  validity_period_hours = var.ca_validity

  allowed_uses = [
    "digital_signature",
    "cert_signing",
    "crl_signing",
  ]
}

output "ca_certificate" {
  value = tls_self_signed_cert.ca.cert_pem
}
