
####### enable flow logs #######
####### role and policy defined in eks-iam.tf ####

locals {
  cloudwatch_log_group_name = "vpc_flow_logs_${aws_vpc.eksVPC.id}"
}

resource "aws_flow_log" "this" {
  iam_role_arn    = aws_iam_role.vpc_flow_log_cloudwatch.arn
  log_destination = aws_cloudwatch_log_group.vpc_cloudwatch_lg.arn
  traffic_type    = "ALL"
  vpc_id          = aws_vpc.eksVPC.id
}

resource "aws_cloudwatch_log_group" "vpc_cloudwatch_lg" {

  name = local.cloudwatch_log_group_name

}








