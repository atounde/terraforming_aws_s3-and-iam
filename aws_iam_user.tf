resource "aws_iam_user" "user" {
  name = var.iam
  path = "/system/"
}

resource "aws_iam_access_key" "key" {
  user = aws_iam_user.user.name
}

resource "aws_iam_user_policy" "user_ro" {
  name = var.policy_name
  user = aws_iam_user.user.name

  policy = <<EOF
{
   "Version":"2012-10-17",
   "Statement":[
      {
         "Effect":"Allow",
         "Action":[
            "s3:ListBucket"
         ],
         "Resource":"arn:aws:s3:::${var.bucket}"
      },
      {
         "Effect":"Allow",
         "Action":[
            "s3:PutObject",
            "s3:GetObject"
         ],
         "Resource":"arn:aws:s3:::${var.bucket}/*"
      }
   ]
}
EOF
}

output "secret" {
  value = [aws_iam_access_key.key.secret, aws_iam_user.user.unique_id]
}
