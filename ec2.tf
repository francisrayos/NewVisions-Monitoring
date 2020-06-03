# NOTE: Instance is launched within the same VPC as Redshift cluster
variable "public_key_path" { }
variable "instance_ami" { }
variable "instance_type" { }

# Route Table for Instance
resource "aws_route_table" "rtb_public" {
  vpc_id = "${aws_vpc.redshift_vpc.id}"

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = "${aws_internet_gateway.redshift_vpc_gw.id}"
  }

  tags {
    Name = "ec2-route-table"
  }

  depends_on = [
    "aws_vpc.redshift_vpc"
  ]
}

# Route Associations Public
resource "aws_route_table_association" "rta_subnet_public" {
  subnet_id      = "${aws_subnet.redshift_subnet_1.id}"
  route_table_id = "${aws_route_table.rtb_public.id}"

  depends_on = [
    "aws_subnet.redshift_subnet_1",
    "aws_route_table.rtb_public"
  ]
}

resource "aws_route_table_association" "rta_subnet_public" {
  subnet_id      = "${aws_subnet.redshift_subnet_2.id}"
  route_table_id = "${aws_route_table.rtb_public.id}"

  depends_on = [
    "aws_subnet.redshift_subnet_2",
    "aws_route_table.rtb_public"
  ]
}

# Security Group for Instance
resource "aws_security_group" "allow-ssh" {
  name = "allow-ssh"
  vpc_id = "${aws_vpc.redshift_vpc.id}"

  ingress {
      from_port   = 22
      to_port     = 22
      protocol    = "tcp"
      cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags {
    Name = "security-group-22"
  }

  depends_on = [
    "aws_vpc.redshift_vpc"
  ]
}

# Key Pairs to SSH to EC2
resource "aws_key_pair" "airflow-key" {
  key_name   = "publicKey1"
  public_key = "${file(var.public_key_path1)}"
}

resource "aws_key_pair" "rstudio-key" {
  key_name   = "publicKey2"
  public_key = "${file(var.public_key_path2)}"
}

# Create the Instance
resource "aws_instance" "airflow_instance" {
  ami                    = "${var.airflow_instance_ami}"
  instance_type          = "${var.airflow_instance_type}"

  # VPC Subnet
  subnet_id              = "${aws_subnet.redshift_subnet_1.id}"

  # Security Group
  vpc_security_group_ids = ["${aws_security_group.allow-ssh.id}"]

  # Public SSH Key
  key_name               = "${aws_key_pair.ec2key.key_name}"

  tags {
    Name = "airflow-instance"
  }

  depends_on = [
    "aws_subnet.redshift_subnet_1",
    "aws_security_group.allow-ssh",
    "aws_key_pair.airflow-key",
  ]
}

resource "aws_instance" "rstudio_instance" {
  ami                    = "${var.rstudio_instance_ami}"
  instance_type          = "${var.rstudio_instance_type}"

  # VPC Subnet
  subnet_id              = "${aws_subnet.redshift_subnet_1.id}"

  # Security Group
  vpc_security_group_ids = ["${aws_security_group.allow-ssh.id}"]

  # Public SSH Key
  key_name               = "${aws_key_pair.ec2key.key_name}"

  tags {
    Name = "rstudio-instance"
  }

  depends_on = [
    "aws_subnet.redshift_subnet_1",
    "aws_security_group.allow-ssh",
    "aws_key_pair.rstudio-key",
  ]
}