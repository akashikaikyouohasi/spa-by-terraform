terraform {
  # terraformのバージョン指定
  required_version = ">=1.0.8"

  # 使用するAWSプロバイダーのバージョン指定（結構更新が速い）
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~>3.67"
    }
  }
}

# 明示的にAWSプロバイダを定義（暗黙的に理解してくれる）
provider "aws" {
  profile = "default"
  region  = "ap-northeast-1"

  # 作成する全リソースに付与するタグ設定
  default_tags {
    tags = {
      env = "dev"
    }
  }
}
