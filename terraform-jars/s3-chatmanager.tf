########## USER MANAGER ############
resource "aws_s3_bucket" "chatmanager" {
  bucket        = "${var.project_name}-${var.chatmanager_name}"
  force_destroy = "false"
  # region        = "${var.aws_region}"
}

resource "aws_s3_bucket_ownership_controls" "chatmanager_ownership" {
  bucket = aws_s3_bucket.chatmanager.id
  rule {
    object_ownership = "BucketOwnerPreferred"
  }
}

resource "aws_s3_bucket_acl" "chatmanager_acl" {
  depends_on = [aws_s3_bucket_ownership_controls.chatmanager_ownership]

  bucket = aws_s3_bucket.chatmanager.id
  acl    = "private"
}

resource "aws_s3_bucket_public_access_block" "chatmanager" {
  bucket = aws_s3_bucket.chatmanager.id

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

resource "aws_s3_object" "chatmanager_jar" {
  bucket = aws_s3_bucket.chatmanager.bucket
  key    = "${var.deployment_number}/${var.chatmanager_jar}"
  source = "${var.chatmanager_jar_loc}/${var.chatmanager_jar}"
}
