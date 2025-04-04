provider "mgc" {
  alias  = "br-se1"
  region = "br-se1"
  api_key = var.mgc_api_key
  object_storage = {
    key_pair = {
      key_id     = var.mgc_obj_key_id
      key_secret = var.mgc_obj_key_secret
    }
  }
}