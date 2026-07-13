#!/bin/bash

echo "=================================================="
echo "          AWS COST CLEANUP VERIFICATION           "
echo "=================================================="

# 1. Check for running or stopped EC2 instances (Stopped instances still charge for storage!)
echo -e "\n[1] Checking EC2 Instances..."
aws ec2 describe-instances \
    --query "Reservations[*].Instances[*].{InstanceId:InstanceId, State:State.Name, Type:InstanceType}" \
    --output table

# 2. Check for unattached EBS Volumes (These charge you per GB/month even if the EC2 is gone!)
echo -e "\n[2] Checking EBS Volumes (Look for 'available' status)..."
aws ec2 describe-volumes \
    --query "Volumes[*].{VolumeId:VolumeId, Size:Size, State:State, AttachedTo:Attachments[0].InstanceId}" \
    --output table

# 3. Check for unassociated Elastic IPs (AWS charges hourly for EIPs that aren't attached to anything!)
echo -e "\n[3] Checking Elastic IPs (Look for missing InstanceId)..."
aws ec2 describe-addresses \
    --query "Addresses[*].{PublicIp:PublicIp, AllocationId:AllocationId, InstanceId:InstanceId}" \
    --output table

# 4. Check for active NAT Gateways (These are incredibly expensive hourly lab killers!)
echo -e "\n[4] Checking NAT Gateways..."
aws ec2 describe-nat-gateways \
    --query "NatGateways[*].{NatGatewayId:NatGatewayId, State:State, VpcId:VpcId}" \
    --output table

# 5. Check if the lab VPC itself is completely gone
echo -e "\n[5] Listing Active VPCs..."
aws ec2 describe-vpcs \
    --query "Vpcs[*].{VpcId:VpcId, CidrBlock:CidrBlock, IsDefault:IsDefault}" \
    --output table

echo -e "\n=================================================="
echo "If the tables above are EMPTY or show 'deleted/available(unattached)', you are safe!"
echo "=================================================="
