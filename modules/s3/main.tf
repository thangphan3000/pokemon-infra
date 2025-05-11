variable "environment" {
  type = string
}

resource "aws_s3_bucket" "pokemon" {
  bucket = "${var.environment}-pokemon-web"

  tags = {
    Environment = var.environment
  }
}
