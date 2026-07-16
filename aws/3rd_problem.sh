#!/bin/bash

# ==========================================
# DEFINE YOUR NEW LAB IDs HERE
# ==========================================
NACL_ID="acl-08869f94b49e82373"
WEB_SG_ID="sg-0db2c34ff4500ae09"
API_SG_ID="sg-04aec74f382a9d0d1"
DB_SG_ID="sg-0a0ad0bea9916a673"

echo "=== Starting Problem 3 Network Fixes ==="

# ------------------------------------------
# PART 1: Web Frontend to API Backend (Port 8080)
# ------------------------------------------
# 1. Allow Web SG to talk OUTBOUND on port 8080
echo "[1/5] Allowing Web SG outbound traffic on port 8080..."
aws ec2 authorize-security-group-egress \
    --group-id "$WEB_SG_ID" \
    --protocol tcp \
    --port 8080 \
    --cidr 0.0.0.0/0

# 2. Allow API SG to accept INBOUND traffic from Web SG on port 8080
echo "[2/5] Allowing Web SG to reach API SG on port 8080..."
aws ec2 authorize-security-group-ingress \
    --group-id "$API_SG_ID" \
    --protocol tcp \
    --port 8080 \
    --source-group "$WEB_SG_ID"

# ------------------------------------------
# PART 2: API Backend to Database (Port 5432)
# ------------------------------------------
# 3. Remove the sneaky inbound deny rule (Rule 100) on the DB Subnet NACL
echo "[3/5] Deleting inbound deny rule 100 on NACL: $NACL_ID..."
aws ec2 delete-network-acl-entry \
    --network-acl-id "$NACL_ID" \
    --ingress \
    --rule-number 100

# 4. Allow the API server to talk OUTBOUND on port 5432 (Postgres)
echo "[4/5] Adding outbound port 5432 to API Security Group: $API_SG_ID..."
aws ec2 authorize-security-group-egress \
    --group-id "$API_SG_ID" \
    --protocol tcp \
    --port 5432 \
    --cidr 0.0.0.0/0

# 5. Allow the Database to accept INBOUND port 5432 traffic from the API Security Group
echo "[5/5] Adding inbound port 5432 to DB Security Group from API Security Group: $DB_SG_ID..."
aws ec2 authorize-security-group-ingress \
    --group-id "$DB_SG_ID" \
    --protocol tcp \
    --port 5432 \
    --source-group "$API_SG_ID"

echo "=== All Problem 3 changes applied! ==="
