terraform {
  //  backend "s3" {
  //    bucket = "terraform-states"
  //    encrypt = true
  //    key = "main-infra/terraform.tfstate"
  //    region = "ap-southeast-1"
  //    dynamodb_table = "terraform-locks"
  //  }
  required_providers {
    aws = {
      source = "hashicorp/aws"
      version = "3.74.0"
    }
  }
}

provider "aws" {
  region = "us-west-2"
}

locals {
  web_instance_type_map = {
    prod = "t3.micro"
    stage = "t3.large"
  }
}

locals {
  web_instance_count_map = {
    stage = 1
    prod = 2
  }
}

resource "aws_instance" "web_one" {
  ami = "ami-00514a528eadbc95b"
  instance_type = local.web_instance_type_map[terraform.workspace]
  count = local.web_instance_count_map[terraform.workspace]

  tags = {
    Name = "Hello netology"
  }
}

locals {
  instances = {
    "t3.micro" = "ami-00514a528eadbc95b"
    "t3.large" = "ami-00514a528eadbc95b"
  }
}

resource "aws_instance" "web" {
  for_each = local.instances

  ami = each.value
  instance_type = each.key

  lifecycle {
    create_before_destroy = true
  }
}

