data "aws_vpc" "default"{
    default = true
}

resource "aws_subnet" "public_subnet" {
    count = 2
    vpc_id = data.aws_vpc.default.id
    cidr_block = cidrsubnet(data.aws_vpc.default.cidr_block,8,count.index+64)
    availability_zone = element(["us-east-2a","us-east-2b","us-east-2c"],count.index)
    tags = {
        Name = "Ohio Public Subnet"
    }
    map_public_ip_on_launch = true
}

data "aws_internet_gateway" "default_igw" {
  filter {
    name   = "attachment.vpc-id"
    values = [data.aws_vpc.default.id]
  }
}

resource "aws_route_table" "public_route_table"{
    vpc_id = data.aws_vpc.default.id
    route  {
        cidr_block = "0.0.0.0/0"
        gateway_id = data.aws_internet_gateway.default_igw.id
    }
    tags = {
        Name = "Public-RouteTable" 
    }
}

resource "aws_route_table_association" "public_route_table_association"{
    count = 2
    route_table_id = aws_route_table.public_route_table.id
    subnet_id = aws_subnet.public_subnet[count.index].id
}

resource "aws_security_group" "strapi_sg"{
    vpc_id = data.aws_vpc.default.id

    ingress {
        from_port = 1337
        to_port = 1337
        protocol = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
    }

    ingress {
        from_port = 80
        to_port = 80
        protocol = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
    }

    ingress {
        from_port = 22
        to_port = 22
        protocol = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
    }

    
    egress {
        from_port = 0
        to_port = 0
        protocol = "-1"
        cidr_blocks = ["0.0.0.0/0"]
    }
}
