## change variables each sesh
rtb="rtb-0390992a69700507c"
nat="nat-04f55a9d7b775ce71"

aws ec2 create-route \
		  --route-table-id $rtb \
		  --destination-cidr-block 0.0.0.0/0 \
		  --gateway-id $nat

aws ec2 describe-route-tables \
		  --route-table-ids $rtb \
		  --query "RouteTables[*].Routes" \
		  --output json
