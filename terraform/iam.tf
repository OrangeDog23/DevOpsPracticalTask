data "aws_iam_policy_document" "testPracticalTask-assume" {
  statement {
    actions = ["sts:AssumeRole"]

    principals {
      type        = "Service"
      identifiers = ["autoscaling.amazonaws.com"]
    }
  }
}

data "aws_iam_policy_document" "testPracticalTask-policy" {
  statement {
    actions = [
      "ssm:Describe*",
      "ssm:Get*",
      "ssm:List*"
    ]
    resources = ["*"]
  }
  statement {
    actions = ["sns:*"]
    resources = ["*"]
  }
}

resource "aws_iam_role" "testPracticalTask" {
  name = "testPracticalTask"
  path   = "/"
  assume_role_policy = data.aws_iam_policy_document.testPracticalTask-assume.json
}

resource "aws_iam_policy" "testPracticalTask" {
  name = "testPracticalTask-policy"
  description = "A test policy"
  policy = data.aws_iam_policy_document.testPracticalTask-policy.json
}

resource "aws_iam_policy_attachment" "testPracticalTask" {
  name       = "testPracticalTask-attachment"
  policy_arn = aws_iam_policy.testPracticalTask.arn
  roles      = [aws_iam_role.testPracticalTask.name]
}

resource "aws_iam_instance_profile" "testPracticalTask" {
  name = "testPracticalTask"
  role = aws_iam_role.testPracticalTask.name
}
