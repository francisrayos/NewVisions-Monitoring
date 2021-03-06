# NOTE: Instance is launched within the same VPC as Redshift cluster
variable "public_key_path1" { }
variable "public_key_path2" { }
variable "airflow_instance_ami" { }
variable "airflow_instance_type" { }
variable "rstudio_instance_ami" { }
variable "rstudio_instance_type" { }

# Route Table for Instance
resource "aws_route_table" "rtb_public" {
  vpc_id = "${aws_vpc.redshift_vpc.id}"

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = "${aws_internet_gateway.redshift_vpc_gw.id}"
  }

  tags = {
    Name = "ec2-route-table"
  }

  depends_on = [
    "aws_vpc.redshift_vpc"
  ]
}

# Route Associations Public
resource "aws_route_table_association" "rta_subnet_public1" {
  subnet_id      = "${aws_subnet.redshift_subnet_1.id}"
  route_table_id = "${aws_route_table.rtb_public.id}"

  depends_on = [
    "aws_subnet.redshift_subnet_1",
    "aws_route_table.rtb_public"
  ]
}

resource "aws_route_table_association" "rta_subnet_public2" {
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

  # Connecting to Airflow
  ingress {
      from_port   = 8080
      to_port     = 8080
      protocol    = "tcp"
      cidr_blocks = ["0.0.0.0/0"]
  }

  # Connecting to Beats
  ingress {
      from_port   = 5015
      to_port     = 5015
      protocol    = "tcp"
      cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "security-group-22"
  }

  depends_on = [
    "aws_vpc.redshift_vpc"
  ]
}

# Key Pairs to SSH to EC2
resource "aws_key_pair" "airflow-key" {
  key_name   = "public-airflow-key"
  public_key = "${file(var.public_key_path1)}"
}

resource "aws_key_pair" "rstudio-key" {
  key_name   = "public-rstudio-key"
  public_key = "${file(var.public_key_path2)}"
}

# Roles and Policies
resource "aws_iam_role_policy" "metricbeat_iam_policy" {
  name = "metricbeat_iam_policy"
  role = "${aws_iam_role.metricbeat_iam_role.id}"

  policy = <<-EOF
  {
    "Version": "2012-10-17",
    "Statement": [
        {
            "Effect": "Allow",
            "Action": [
              "ec2:DescribeRegions",
              "ec2:DescribeInstances",
              "ec2:DescribeTags",
              "cloudwatch:ListMetrics",
              "cloudwatch:GetMetricData",
              "cloudwatch:PutMetricData",
              "cloudwatch:GetMetricStatistics",
              "iam:ListAccountAliases", 
              "sts:GetCallerIdentity"
            ],
            "Resource": "*"
        }
    ]
  }
  EOF
}

resource "aws_iam_role" "metricbeat_iam_role" {
  name = "metricbeat_iam_role"

  assume_role_policy = <<-EOF
  {
    "Version": "2012-10-17",
    "Statement": [
      {
        "Action": "sts:AssumeRole",
        "Principal": {
          "Service": "ec2.amazonaws.com"
        },
        "Effect": "Allow",
        "Sid": ""
      }
    ]
  }
  EOF

  tags = {
    Name = "metricbeat-role"
  }
}

resource "aws_iam_role_policy" "cloudwatch_agent_server_role_policy" {
  name = "cloudwatch_agent_server_role_policy"
  role = "${aws_iam_role.cloudwatch_agent_server_role.id}"

  policy = <<-EOF
  {
      "Version": "2012-10-17",
      "Statement": [
          {
              "Effect": "Allow",
              "Action": [
                  "cloudwatch:PutMetricData",
                  "ec2:DescribeVolumes",
                  "ec2:DescribeTags",
                  "logs:PutLogEvents",
                  "logs:DescribeLogStreams",
                  "logs:DescribeLogGroups",
                  "logs:CreateLogStream",
                  "logs:CreateLogGroup"
              ],
              "Resource": "*"
          },
          {
              "Effect": "Allow",
              "Action": [
                  "ssm:GetParameter"
              ],
              "Resource": "arn:aws:ssm:*:*:parameter/AmazonCloudWatch-*"
          }
      ]
  }
  EOF
}

resource "aws_iam_role" "cloudwatch_agent_server_role" {
  name = "cloudwatch_agent_server_role"

  assume_role_policy = <<-EOF
  {
    "Version": "2012-10-17",
    "Statement": [
      {
        "Action": "sts:AssumeRole",
        "Principal": {
          "Service": "ec2.amazonaws.com"
        },
        "Effect": "Allow",
        "Sid": ""
      }
    ]
  }
  EOF

  tags = {
    Name = "cloudwatch_agent_server_role"
  }
}

# Instance Profiles
resource "aws_iam_instance_profile" "metricbeat_profile" {
  name = "metricbeat_profile"
  role = "${aws_iam_role.metricbeat_iam_role.name}"
}

resource "aws_iam_instance_profile" "cloudwatch_agent_server_profile" {
  name = "cloudwatch_agent_server_profile"
  role = "${aws_iam_role.cloudwatch_agent_server_role.name}"
}

# Create the Instance
resource "aws_instance" "airflow_instance" {
  ami                    = "${var.rstudio_instance_ami}"
  instance_type          = "${var.airflow_instance_type}"

  # VPC Subnet
  subnet_id              = "${aws_subnet.redshift_subnet_1.id}"

  # Security Group
  vpc_security_group_ids = ["${aws_security_group.allow-ssh.id}"]

  # Public SSH Key
  key_name               = "${aws_key_pair.airflow-key.key_name}"

  # IAM Instance Profile
  iam_instance_profile   = "${aws_iam_instance_profile.metricbeat_profile.name}"

  # Enable detailed monitoring
  monitoring             = true

  tags = {
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
  key_name               = "${aws_key_pair.rstudio-key.key_name}"

  # IAM Instance Profile
  iam_instance_profile   = "${aws_iam_instance_profile.cloudwatch_agent_server_profile.name}"

  # Enable detailed monitoring
  monitoring             = true

  tags = {
    Name = "rstudio-instance"
  }

  depends_on = [
    "aws_subnet.redshift_subnet_1",
    "aws_security_group.allow-ssh",
    "aws_key_pair.rstudio-key",
  ]
}