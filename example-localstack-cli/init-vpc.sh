#!/bin/bash

# variables that can be overwritten via environment variables
vpc_name=${VPC_NAME-"MyVPC"}
vpc_cidr=${VPC_CIDR-"10.0.0.0/16"}
subnet_1_cidr=${SUBNET_1_CIDR-"10.0.1.0/24"}
subnet_2_cidr=${SUBNET_2_CIDR-"10.0.2.0/24"}
subnet_3_cidr=${SUBNET_3_CIDR-"10.0.3.0/24"}

# helper to create subnets
function create-subnet() {
    vpc_id=$1
    cidr=$2

    subnet=$(awslocal ec2 create-subnet --query 'Subnet.SubnetId' --output text --cidr-block ${cidr} --vpc-id ${vpc_id})
    awslocal ec2 create-tags --tags Key=aws-cdk:subnet-name,Value=private --resources ${subnet}
    awslocal ec2 create-tags --tags Key=aws-cdk:subnet-type,Value=Isolated --resources ${subnet}
    echo ${subnet}
}

# create VPC
vpc_id=$(awslocal ec2 create-vpc --cidr-block ${vpc_cidr} --query Vpc.VpcId --output text)
echo ${vpc_id}
awslocal ec2 create-tags --tags Key=Name,Value=${vpc_name} --resources ${vpc_id}

# create subnets
create-subnet "${vpc_id}" "${subnet_1_cidr}"
create-subnet "${vpc_id}" "${subnet_2_cidr}"
create-subnet "${vpc_id}" "${subnet_3_cidr}"
