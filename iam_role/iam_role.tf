variable "iam_role_name" {}

# To Create the Lambda
resource "aws_iam_role" "iam_role_resource" {
    name = var.iam_role_name
    assume_role_policy = jsonencode({
      "Version": "2012-10-17",
      "Statement": [
        {
          "Action": "sts:AssumeRole",
          "Principal": {
            "Service": "lambda.amazonaws.com"
          },
          "Effect": "Allow",
          "Sid": ""
        }
      ]
    })
}

# To Enable Logs
resource "aws_iam_role_policy" "log_writer" {
  name = "lambda-log-writer"
  role = aws_iam_role.iam_role_resource.id

  policy = jsonencode({
    "Version": "2012-10-17",
    "Statement": [
      {
        "Effect": "Allow",
        "Action": [
          "logs:CreateLogStream",
          "logs:PutLogEvents"
        ],
        "Resource": "arn:aws:logs:*:*:*"
      }
    ]
  })
}

# To Trigger EC2 Lifecycle methods e.g. Start/Stop
# resource "aws_iam_role_policy" "ec2_lifecycle_manager" {
#   name = "lambda-ec2-lifecycle-manager"
#   role = aws_iam_role.iam_role_resource.id

#   policy = jsonencode({
#     "Version": "2012-10-17",
#     "Statement": [
#       {
#           "Effect": "Allow",
#           "Action": [
#             "ec2:Describe*",
#             "ec2:Start*",
#             "ec2:Stop*"
#           ],
#           "Resource": "*"
#       }
#     ]
#   })
# }

output "arn" {
  value = aws_iam_role.iam_role_resource.arn
}