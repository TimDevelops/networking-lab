#!/bin/bash

# Set your VPC ID
VPC_ID="vpc-034edb70c282dca76"

echo "=== SECURITY GROUPS ==="
aws ec2 describe-security-groups \
    --filters "Name=vpc-id,Values=$VPC_ID" \
    --query "SecurityGroups[*].{GroupName:GroupName, GroupId:GroupId}" \
    --output table

echo "=== SUBNETS ==="
aws ec2 describe-subnets \
    --filters "Name=vpc-id,Values=$VPC_ID" \
    --query "Subnets[*].{SubnetId:SubnetId, CidrBlock:CidrBlock, Name:Tags[?Key=='Name'].Value | [0]}" \
    --output table

echo "=== NETWORK ACLS ==="
aws ec2 describe-network-acls \
    --filters "Name=vpc-id,Values=$VPC_ID" \
    --query "NetworkAcls[*].{NaclId:NetworkAclId, SubnetAssociations:Associations[*].SubnetId}" \
    --output json

echo "=== PROBLEM 1 ==="
echo "NAT Gateway ID"
aws ec2 describe-nat-gateways \
	--query "NatGateways[*].{NatGatewayId:NatGatewayId, State:State, Subnet:SubnetId}" \
	--output json
echo "Route Table ID"
aws ec2 describe-route-tables \
	--query "RouteTables[*].{RouteTableId:RouteTableId, Associations:Associations[*].SubnetId}" \
	--output json

echo "=== PROBLEM 2 ==="
aws route53 list-hosted-zones-by-name --dns-name example.com --query "HostedZones[0].Id" --output text

echo "Update file://change-records.json and then run this command:/n 
aws route53 change-resource-record-sets  \
	--hosted-zone-id [NEW ID] \
	--change-batch file://change-records.json"

echo "=== PROBLEM 3 ===="
echo "Run problem 3 script, dummy"
