terraform {
  required_version = ">= 1.6.0"

  backend "s3" {
    bucket       = "kpotapenko-fp-tfstate-2025"
    key          = "fp/terraform.tfstate"
    region       = "us-west-2"
    use_lockfile = true
    encrypt      = true
  }

  required_providers {
    null = {
      source  = "hashicorp/null"
      version = "~> 3.2"
    }
    aws        = { source = "hashicorp/aws", version = ">= 5.0" }
    kubernetes = { source = "hashicorp/kubernetes", version = ">= 2.28" }
    helm       = { source = "hashicorp/helm", version = ">= 2.11" }
  }
}
