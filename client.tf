variable "clients" {
  type = map
  description = "describe your variable"
  default = {}
}

variable "default_client_subject" {
  type = map
  description = ""
  default = {}
}

variable "client_csrs" {
  type = map
  description = "describe your variable"
  default = {}
}

variable "client_certificate_validity" {
  type = number
  default = 43800
}

resource "tls_private_key" "pem_client" {
  for_each = var.clients
  algorithm = var.algorithm
}

resource "tls_cert_request" "csr_client" {
  for_each = var.clients
  private_key_pem = tls_private_key.pem_client[each.key].private_key_pem
  dns_names = [each.key]

  subject {
    country             = try(each.value.country, try(var.default_client_subject.country, var.default_subject.country))
    province            = try(each.value.province, try(var.default_client_subject.province, var.default_subject.province))
    locality            = try(each.value.locality, try(var.default_client_subject.locality, var.default_subject.locality))
    common_name         = try(each.value.cn, try(var.default_client_subject.cn, var.default_subject.cn))
    organization        = try(each.value.org, try(var.default_client_subject.org, var.default_subject.org))
    organizational_unit = try(each.value.ou, try(var.default_client_subject.ou, var.default_subject.ou))
  }
}

resource "tls_locally_signed_cert" "client" {
  for_each = var.clients
  cert_request_pem = tls_cert_request.csr_client[each.key].cert_request_pem
  ca_private_key_pem = tls_private_key.pem_ca.private_key_pem
  ca_cert_pem = tls_self_signed_cert.ca.cert_pem

  validity_period_hours = var.client_certificate_validity

  allowed_uses = [
    "digital_signature",
    "key_encipherment",
    "server_auth",
    "client_auth",
  ]
}

resource "pkcs12_from_pem" "client" {
  for_each = var.clients
  ca_pem          = tls_self_signed_cert.ca.cert_pem
  cert_pem        = tls_locally_signed_cert.client[each.key].cert_pem
  private_key_pem = tls_private_key.pem_client[each.key].private_key_pem
  password = "123" # Testing purposes
  encoding = "legacyRC2"
}

output "client_certificates" {
  value = [ for cert in tls_locally_signed_cert.client : cert.cert_pem ]
  sensitive = false
}

output "client_certificates_pkcs12" {
  value = [ for cert in pkcs12_from_pem.client : cert.result ]
  sensitive = true
}