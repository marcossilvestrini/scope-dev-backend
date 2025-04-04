terraform {
  required_providers {
    mgc = {
      source  = "registry.terraform.io/magalucloud/mgc"
      version = "0.32.2"
    }
  }
  backend "s3" {
    bucket                      = "br-se1-backend-tfstate"
    key                         = "devops/clusters/prod/backstage-cluster-01.tfstate"
    region                      = "br-se1"
    skip_region_validation      = true
    skip_credentials_validation = true
    skip_requesting_account_id  = true
    skip_s3_checksum            = true
    endpoints = {
      s3 = "https://br-se1.magaluobjects.com/"
    }
  }
}
