########## POST MANAGER ############
resource "aws_s3_bucket" "postmanager" {
  bucket        = "${var.project_name}-${var.postmanager_name}"
  force_destroy = "false"
  # region        = "${var.aws_region}"
}

resource "aws_s3_bucket_ownership_controls" "postmanager_ownership" {
  bucket = aws_s3_bucket.postmanager.id
  rule {
    object_ownership = "BucketOwnerPreferred"
  }
}

resource "aws_s3_bucket_acl" "postmanager_acl" {
  depends_on = [aws_s3_bucket_ownership_controls.postmanager_ownership]

  bucket = aws_s3_bucket.postmanager.id
  acl    = "private"
}

resource "aws_s3_bucket_public_access_block" "postmanager" {
  bucket = aws_s3_bucket.postmanager.id

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

resource "aws_s3_object" "postmanager_jar" {
  bucket = aws_s3_bucket.postmanager.bucket
  key    = "${var.deployment_number}/${var.postmanager_jar}"
  source = "${var.postmanager_jar_loc}/${var.postmanager_jar}"
}