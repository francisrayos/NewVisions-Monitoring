# resource "aws_sqs_queue" "q" {
#   name = "sqs-queue"
# }

# resource "aws_sqs_queue_policy" "q_policy" {
#   queue_url = "${aws_sqs_queue.q.id}"

#   policy = <<POLICY
#   {
#     "Version": "2012-10-17",
#     "Id": "sqspolicy",
#     "Statement": [
#       {
#         "Sid": "example-statement-ID",
#         "Effect": "Allow",
#         "Principal": {
#           "AWS":"*"   
#         },
#         "Action": "SQS:SendMessage",
#         "Resource": "${aws_sqs_queue.q.arn}",
#         "Condition": {
#           "ArnLike": { "aws:SourceArn": "arn:aws:s3:*:*:new-visions-s3" }
#         }
#       }
#     ]
#   }
#   POLICY
# }