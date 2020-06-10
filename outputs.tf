# output "this_sqs_queue_id" {
#   description = "The URL for the created Amazon SQS queue"
#   value       = "${aws_sqs_queue.q.this_sqs_queue_id}"
# }

# output "this_sqs_queue_arn" {
#   description = "The ARN of the SQS queue"
#   value       = "${aws_sqs_queue.q.this_sqs_queue_arn}"
# }

# output "vpc_id" {
#   value = "${aws_vpc.vpc.id}"
# }
# output "public_subnets" {
#   value = ["${aws_subnet.subnet_public.id}"]
# }
# output "public_route_table_ids" {
#   value = ["${aws_route_table.rtb_public.id}"]
# }
# output "public_instance_ip" {
#   value = ["${aws_instance.testInstance.public_ip}"]
# }