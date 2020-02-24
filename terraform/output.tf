output "jenkins_ip_addr" {
  value = aws_instance.jenkins.public_ip
}

output "jenkins_lb_dns_name" {
  value = aws_lb.testPracticalTask.dns_name
}
