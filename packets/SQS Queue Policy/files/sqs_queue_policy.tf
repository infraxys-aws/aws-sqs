
resource "aws_sqs_queue_policy" "$instance.getAttribute("policy_name")" {
	
  queue_url = aws_sqs_queue.${instance.parent.getAttribute("queue_name")}.id
  
  policy = <<EOF
$instance.getAttribute("policy")
EOF
  
}