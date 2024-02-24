variable "ca_country" {
  type = string
  description = "country the ca certificate is issued from"
}
variable "ca_province" {
  type = string
  description = "province the ca certificate is issued from"
}
variable "ca_locality" {
  type = string
  description = "locality the ca certificate is issued from"
}
variable "ca_cn" {
  type = string
  description = "common name of the ca certificate"
}
variable "ca_org" {
  type = string
  description = "organization of the ca certificate"
}
variable "ca_org_name" {
  type = string
  description = "organization name of the ca certificate"
}
variable "ca_validity" {
  type = number
  default = 43800
  description = "length of the validity of the certificate"
}

/**
 * Private key for use by the self-signed certificate, used for
 * future generation of child certificates. As long as the state
 * remains unchanged, the private key and certificate should not
 * re-update at every re-run unless any variable is changed.
 */
resource "tls_private_key" "pem_ca" {
  algorithm = var.algorithm
}

/**
 * Generation of the CA Certificate, which is in turn used by
 * the client.tf and server.tf submodules to generate child
 * certificates
 */
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

/**
 * Return the certificate itself. It's the responsibility of
 * the user of this module to determine whether the certificate should
 * be stored locally, transferred or submitted directly to a cloud
 * service
 */
output "ca_certificate" {
  value = tls_self_signed_cert.ca.cert_pem
  sensitive = true
  description = "generated ca certificate"
}
