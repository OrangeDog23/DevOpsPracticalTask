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
  description = "An ASG policy"
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

# jenkins

data "aws_iam_policy_document" "testPracticalTask_jenkins_assume" {
  statement {
    actions = ["sts:AssumeRole"]

    principals {
      type        = "Service"
      identifiers = ["ec2.amazonaws.com"]
    }
  }
}

data "aws_iam_policy_document" "testPracticalTask_jenkins_policy" {
  statement {
    actions = [
      "ec2:AttachVolume",
      "ec2:AuthorizeSecurityGroupIngress",
      "ec2:CopyImage",
      "ec2:CreateImage",
      "ec2:CreateKeypair",
      "ec2:CreateSecurityGroup",
      "ec2:CreateSnapshot",
      "ec2:CreateTags",
      "ec2:CreateVolume",
      "ec2:DeleteKeyPair",
      "ec2:DeleteSecurityGroup",
      "ec2:DeleteSnapshot",
      "ec2:DeleteVolume",
      "ec2:DeregisterImage",
      "ec2:DescribeImageAttribute",
      "ec2:DescribeImages",
      "ec2:DescribeInstances",
      "ec2:DescribeInstanceStatus",
      "ec2:DescribeRegions",
      "ec2:DescribeSecurityGroups",
      "ec2:DescribeSnapshots",
      "ec2:DescribeSubnets",
      "ec2:DescribeTags",
      "ec2:DescribeVolumes",
      "ec2:DetachVolume",
      "ec2:GetPasswordData",
      "ec2:ModifyImageAttribute",
      "ec2:ModifyInstanceAttribute",
      "ec2:ModifySnapshotAttribute",
      "ec2:RegisterImage",
      "ec2:RunInstances",
      "ec2:StopInstances",
      "ec2:TerminateInstances"
    ]
    resources = ["*"]
  }
}

resource "aws_iam_role" "testPracticalTask_jenkins" {
  name = "testPracticalTask-jenkins"
  path   = "/"
  assume_role_policy = data.aws_iam_policy_document.testPracticalTask_jenkins_assume.json
}

resource "aws_iam_policy" "testPracticalTask_jenkins" {
  name = "testPracticalTask-jenkins-policy"
  description = "A jenkins policy"
  policy = data.aws_iam_policy_document.testPracticalTask_jenkins_policy.json
}

resource "aws_iam_policy_attachment" "testPracticalTask_jenkins" {
  name       = "testPracticalTask-jenkins-attachment"
  policy_arn = aws_iam_policy.testPracticalTask_jenkins.arn
  roles      = [aws_iam_role.testPracticalTask_jenkins.name]
}

resource "aws_iam_instance_profile" "testPracticalTask_jenkins" {
  name = "testPracticalTask-jenkins"
  role = aws_iam_role.testPracticalTask_jenkins.name
}

