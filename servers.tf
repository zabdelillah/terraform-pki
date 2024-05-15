variable "servers" {
  type        = map(any)
  description = "keys of machines to generate certificates for, values of the certificate subject"
  default     = {}
}

variable "default_server_subject" {
  type        = map(any)
  description = "fallback values for certificate subjects, should the value of a server be null"
  default     = {}
}

variable "server_csrs" {
  type        = map(any)
  description = "csrs to use instead of generating them within this module"
  default     = {}
}

variable "server_certificate_validity" {
  type        = number
  default     = 43800
  description = "length of the validity of the certificate"
}

resource "tls_private_key" "pem_server" {
  for_each  = var.servers
  algorithm = var.algorithm
}

resource "tls_cert_request" "csr_server" {
  for_each        = var.servers
  private_key_pem = tls_private_key.pem_server[each.key].private_key_pem
  dns_names       = [each.key]

  subject {
    country             = try(each.value.country, try(var.default_server_subject.country, var.default_subject.country))
    province            = try(each.value.province, try(var.default_server_subject.province, var.default_subject.province))
    locality            = try(each.value.locality, try(var.default_server_subject.locality, var.default_subject.locality))
    common_name         = try(each.value.cn, try(var.default_server_subject.cn, var.default_subject.cn))
    organization        = try(each.value.org, try(var.default_server_subject.org, var.default_subject.org))
    organizational_unit = try(each.value.ou, try(var.default_server_subject.ou, var.default_subject.ou))
  }
}

resource "tls_locally_signed_cert" "server" {
  for_each           = var.servers
  cert_request_pem   = tls_cert_request.csr_server[each.key].cert_request_pem
  ca_private_key_pem = tls_private_key.pem_ca.private_key_pem
  ca_cert_pem        = tls_self_signed_cert.ca.cert_pem

  validity_period_hours = var.client_certificate_validity

  allowed_uses = [
    "digital_signature",
    "key_encipherment",
    "server_auth",
    "client_auth",
  ]
}

resource "pkcs12_from_pem" "server" {
  for_each        = var.servers
  ca_pem          = tls_self_signed_cert.ca.cert_pem
  cert_pem        = tls_locally_signed_cert.server[each.key].cert_pem
  private_key_pem = tls_private_key.pem_server[each.key].private_key_pem
  password        = "123" # Testing purposes
  encoding        = "legacyRC2"
}

output "server_keys" {
  value       = [for cert in tls_locally_signed_cert.server : cert.private_key_pem]
  description = "generated server certificate"
  sensitive   = true
}

output "server_certificates" {
  value       = [for cert in tls_locally_signed_cert.server : cert.cert_pem]
  description = "generated server certificate"
  sensitive   = true
}

output "server_certificates_pkcs12" {
  value       = [for cert in pkcs12_from_pem.server : cert.result]
  description = "combined ca certificate, private key and ca certificate in pkcs12 format"
  sensitive   = true
}
