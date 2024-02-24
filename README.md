## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_pkcs12"></a> [pkcs12](#requirement\_pkcs12) | 0.2.5 |
| <a name="requirement_tls"></a> [tls](#requirement\_tls) | 4.0.5 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_tls"></a> [tls](#provider\_tls) | 4.0.5 |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [tls_cert_request.csr_client](https://registry.terraform.io/providers/hashicorp/tls/4.0.5/docs/resources/cert_request) | resource |
| [tls_locally_signed_cert.client](https://registry.terraform.io/providers/hashicorp/tls/4.0.5/docs/resources/locally_signed_cert) | resource |
| [tls_private_key.pem_ca](https://registry.terraform.io/providers/hashicorp/tls/4.0.5/docs/resources/private_key) | resource |
| [tls_private_key.pem_client](https://registry.terraform.io/providers/hashicorp/tls/4.0.5/docs/resources/private_key) | resource |
| [tls_self_signed_cert.ca](https://registry.terraform.io/providers/hashicorp/tls/4.0.5/docs/resources/self_signed_cert) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_algorithm"></a> [algorithm](#input\_algorithm) | algorithm to use for encryption | `string` | `"RSA"` | no |
| <a name="input_ca_cn"></a> [ca\_cn](#input\_ca\_cn) | n/a | `string` | n/a | yes |
| <a name="input_ca_country"></a> [ca\_country](#input\_ca\_country) | n/a | `string` | n/a | yes |
| <a name="input_ca_locality"></a> [ca\_locality](#input\_ca\_locality) | n/a | `string` | n/a | yes |
| <a name="input_ca_org"></a> [ca\_org](#input\_ca\_org) | n/a | `string` | n/a | yes |
| <a name="input_ca_org_name"></a> [ca\_org\_name](#input\_ca\_org\_name) | n/a | `string` | n/a | yes |
| <a name="input_ca_province"></a> [ca\_province](#input\_ca\_province) | n/a | `string` | n/a | yes |
| <a name="input_ca_validity"></a> [ca\_validity](#input\_ca\_validity) | n/a | `number` | `43800` | no |
| <a name="input_clients"></a> [clients](#input\_clients) | describe your variable | `map` | `{}` | no |
| <a name="input_default_client_subject"></a> [default\_client\_subject](#input\_default\_client\_subject) | n/a | `map` | `{}` | no |
| <a name="input_default_subject"></a> [default\_subject](#input\_default\_subject) | n/a | `map` | <pre>{<br>  "cn": "zabdelillah.private_ca_chain",<br>  "country": "Canada",<br>  "locality": "Montreal",<br>  "org": "Zak Abdel-Illah",<br>  "ou": "Terraform Module"<br>}</pre> | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_ca_certificate"></a> [ca\_certificate](#output\_ca\_certificate) | n/a |
| <a name="output_client_certificates"></a> [client\_certificates](#output\_client\_certificates) | n/a |
