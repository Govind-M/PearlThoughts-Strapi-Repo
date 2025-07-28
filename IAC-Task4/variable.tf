variable "db_username" {
  type        = string
  description = "Username of db"
  default = "strapi"
}

variable "db_password" {
  type        = string
  description = "Password for db"
}

variable "db_name" {
  type        = string
  description = "name for db"
}

variable "key_name" {
  type        = string
  description = "Ohio Key name"
}

variable "APP_KEYS" {
  description = "Strapi application secret keys"
  type        = string
}

variable "API_TOKEN_SALT" {
  description = "Salt for API tokens"
  type        = string
}

variable "ADMIN_JWT_SECRET" {
  description = "JWT secret for Strapi Admin"
  type        = string
}