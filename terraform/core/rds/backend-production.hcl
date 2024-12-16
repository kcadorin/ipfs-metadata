region               = "us-east-1"
bucket               = "block-party-production-core-terraform-state"
key                  = "terraform.tfstate"
dynamodb_table       = "block-party-production-core-terraform-state-lock"
workspace_key_prefix = "rds"
encrypt              = true
