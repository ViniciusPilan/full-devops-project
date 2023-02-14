variable region {
    type = string
    default = "us-east-1"
    description = "Standard region for this project"
}

variable vpc {
    type = string
    default = "vpc-09855d8bef1576d80"
    description = "Default Amazon VPC"
}

variable ami {
    type = string
    default = "ami-0557a15b87f6559cf"
    description = "Standard Image for this project"
}

variable instance_type {
    type = string
    default = "t2.micro"
    description = "Standard Instance Type for this project"
}

# Bucket
variable bucket_name {
    type = string
    default = "s3-website-content.vinipilan.com"
    description = "Name of images bucket"
}

# Web Server ----------------------------------------------------
## EC2 Key Pair
variable web_server_kp {
    type = string
    default = "ws-kp"
    description = "Key pair name for web server access"
}



# Control Server ----------------------------------------------------
## EC2 Key Pair
variable control_server_kp {
    type = string
    default = "cs-kp"
    description = "Key pair name for control server access"
}


