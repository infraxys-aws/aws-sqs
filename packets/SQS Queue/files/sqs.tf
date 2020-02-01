#set ($queueName = $instance.getAttribute("queue_name"))
#set ($queuePolicy = $instance.getAttribute("queue_policy").trim())
#set ($redrivePolicy = $instance.getAttribute("redrive_policy").trim())

resource "aws_sqs_queue" "$queueName" {
  name                      = "$queueName"
  visibility_timeout_seconds = $instance.getAttribute("visibility_timeout_seconds")
  message_retention_seconds = $instance.getAttribute("message_retention_seconds")
  max_message_size          = $instance.getAttribute("max_message_size")
  delay_seconds				= $instance.getAttribute("delay_seconds")
  receive_wait_time_seconds = $instance.getAttribute("receive_wait_time_seconds")
#if ($queuePolicy != "")  
  policy = <<EOF
$queuePolicy
EOF
#end
#if ($redrivePolicy != "")
  redrive_policy = <<EOF 
$redrivePolicy
EOF
#end
  fifo_queue					= $instance.getBoolean("fifo_queue")
  content_based_deduplication = $instance.getBoolean("content_based_deduplication")
  kms_master_key_id			= "$instance.getAttribute("kms_master_key_id")"
  kms_data_key_reuse_period_seconds = $instance.getAttribute("kms_data_key_reuse_period_seconds")
  tags = {
$instance.getAttribute("tags")
  }
}

#if (! $instance.getParentInstanceByPacketType("TERRAFORM-AWS-RUNNER"))
provider "aws" {
  region = "us-east-1"
  version = "~> 2.32.0"
}

output "id" {
  description = "The URL for the created Amazon SQS queue"
  value       = "${D}{aws_sqs_queue.${queueName}.id}"
}

output "arn" {
  description = "The ARN of the SQS queue"
  value       = "${D}{aws_sqs_queue.${queueName}.arn}"
}
#end