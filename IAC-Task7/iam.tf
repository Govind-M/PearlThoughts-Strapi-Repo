data "aws_iam_policy_document" "assume_role_policy" {
    statement {
        actions = ["sts:AssumeRole"]
        principals {
            type = "Service"
            identifiers = ["ecs-tasks.amazonaws.com"]
        }
    }
}

resource "aws_iam_role" "ecsTaskExecutionRole" {
    name = "ecs-task-execution-role-gov"
    assume_role_policy = data.aws_iam_policy_document.assume_role_policy.json
    tags = {
      Name = "ecs-iam-role"
    }
}



resource "aws_iam_role_policy_attachment" "ecsTaskExecutionRole_policy" {
    role = aws_iam_role.ecsTaskExecutionRole.name
    policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonECSTaskExecutionRolePolicy"
}