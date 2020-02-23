data "aws_iam_policy_document" "testPracticalTask" {
  statement {
    sid = "1"

    actions = [
      "sns:*",
      "ssm:*",
    ]

    resources = [
      "*",
    ]
  }
}


resource "aws_iam_role" "testPracticalTask" {
  name = "testPracticalTask"
  path   = "/"
  assume_role_policy = data.aws_iam_policy_document.testPracticalTask.json
}
