# # Random Number
# resource "random_id" "random_number" { 
#     byte_length = 4
# }

# resource "aws_ecr_repository" "rsync_repo" {
#   name = "rsync-${random_id.random_number.hex}"
# }

# resource "aws_ecr_repository_policy" "RsyncRepoPolicy" {
#   repository = aws_ecr_repository.rsync_repo.name
#   policy     = <<EOF
# {
#     "Version": "2008-10-17",
#     "Statement": [
#         {
#             "Sid": "AllowAll",
#             "Effect": "Allow",
#             "Principal": {
#                 "AWS": [
#                     "arn:aws:iam::778703675311:root",
#                     "arn:aws:iam::808223772320:root"
#                 ]},
#             "Action": "ecr:*"
#         }
#     ]
# }
# EOF
# }


# resource "aws_ecr_repository" "meindsl_repo" {
#   name = "meindsl-${random_id.random_number.hex}"
# }

# resource "aws_ecr_repository_policy" "meindslRepoPolicy" {
#   repository = aws_ecr_repository.meindsl_repo.name
#   policy     = <<EOF
# {
#     "Version": "2008-10-17",
#     "Statement": [
#         {
#             "Sid": "AllowAll",
#             "Effect": "Allow",
#             "Principal": {
#                 "AWS": [
#                     "arn:aws:iam::412599132833:root",
#                     "arn:aws:iam::778703675311:root",
#                     "arn:aws:iam::808223772320:root"
#                 ]},
#             "Action": "ecr:*"
#         }
#     ]
# }
# EOF
# }


# resource "aws_ecr_repository" "vfksc_repo" {
#   name = "vfksc-${random_id.random_number.hex}"
# }

# resource "aws_ecr_repository_policy" "vfkscRepoPolicy" {
#   repository = aws_ecr_repository.vfksc_repo.name
#   policy     = <<EOF
# {
#     "Version": "2008-10-17",
#     "Statement": [
#         {
#             "Sid": "AllowAll",
#             "Effect": "Allow",
#             "Principal": {
#                 "AWS": [
#                     "arn:aws:iam::412599132833:root",
#                     "arn:aws:iam::778703675311:root",
#                     "arn:aws:iam::808223772320:root"
#                 ]},
#             "Action": "ecr:*"
#         }
#     ]
# }
# EOF
# }

