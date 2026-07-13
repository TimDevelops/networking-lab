# 1. Set your VPC ID
VPC_ID="vpc-012d5e8f88330b3ed"

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
