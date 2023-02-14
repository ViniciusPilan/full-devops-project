# Web Server 01
output "web_server_01_id" {
    value = aws_instance.web_server_01.id
}

output "web_server_01_eip_public_ip" {
    value = aws_eip.web_server_01_eip.public_ip
}

output "web_server_01_eip_public_dns" {
    value = aws_eip.web_server_01_eip.public_dns
}


# Web Server 02
output "web_server_02_id" {
    value = aws_instance.web_server_02.id
}

output "web_server_02_eip_public_ip" {
    value = aws_eip.web_server_02_eip.public_ip
}

output "web_server_02_eip_public_dns" {
    value = aws_eip.web_server_02_eip.public_dns
}


# Control Server
output "control_server_id" {
    value = aws_instance.control_server.id
}

output "control_server_eip_public_ip" {
    value = aws_eip.control_server_eip.public_ip
}

output "control_server_eip_public_dns" {
    value = aws_eip.control_server_eip.public_dns
}


# Images bucket
output "bucket-name" {
    value = aws_s3_bucket.bucket_web_server.bucket
}