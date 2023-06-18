

resource "aws_s3_bucket" "terraform-backend-bucket" {
  bucket = "backend-bucket-husein"
  tags = {
    Name        = "tf-bucket"
    Environment = "dev"
  }
}

resource "aws_kms_key" "mykey" {
  description = "This key is used to encrypt bucket objects"
  deletion_window_in_days = 10
}

resource "aws_s3_bucket_server_side_encryption_configuration" "example" {
  bucket = aws_s3_bucket.terraform-backend-bucket.id

  rule {
    apply_server_side_encryption_by_default {
      kms_master_key_id = aws_kms_key.mykey.arn
      sse_algorithm     = "aws:kms"
    }
  }
}

resource "aws_s3_bucket_versioning" "versioning_bucket_enabled" {
  bucket = aws_s3_bucket.terraform-backend-bucket.id
  versioning_configuration {
    status = "Enabled"
  }
}

terraform {
    backend "s3" {
        bucket = "backend-bucket-husein"
        key = "terraform.tfstate"
        region = "eu-central-1"
    }
}

resource "aws_dynamodb_table" "terraform_locks" {
    name = "terraform-state-locking"
    billing_mode = "PAY_PER_REQUEST"
    hash_key = "LockID"

    attribute {
        name = "LockID"
        type = "S"
    }
}

