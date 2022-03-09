#################
### SPA用バケットに確認用のindex.hmtlを作成
#################
resource "aws_s3_bucket_object" "index_page" {
  bucket = aws_s3_bucket.single-page-application.id
  key = "index.html"
  source = "../origin_contents/index.html"
  content_type = "text/html"
  etag = filemd5("../origin_contents/index.html")
}