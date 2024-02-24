variable "default_subject" {
  type = map
  description = ""
  default = {
    country = "Canada"
    locality = "Montreal"
    cn = "zabdelillah.private_ca_chain"
    org = "Zak Abdel-Illah"
    ou = "Terraform Module"
  }
}

variable "algorithm" {
  type = string
  description = "algorithm to use for encryption"
  default = "RSA"
}