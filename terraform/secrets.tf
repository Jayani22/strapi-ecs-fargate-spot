resource "random_password" "jwt_secret" {
  length  = 32
  special = false
}

resource "random_password" "admin_jwt_secret" {
  length  = 32
  special = false
}

resource "random_password" "api_token_salt" {
  length  = 32
  special = false
}

resource "random_password" "app_key_1" {
  length  = 32
  special = false
}

resource "random_password" "app_key_2" {
  length  = 32
  special = false
}

resource "random_password" "app_key_3" {
  length  = 32
  special = false
}

resource "random_password" "app_key_4" {
  length  = 32
  special = false
}

locals {
  app_keys = join(",", [
    random_password.app_key_1.result,
    random_password.app_key_2.result,
    random_password.app_key_3.result,
    random_password.app_key_4.result
  ])
}