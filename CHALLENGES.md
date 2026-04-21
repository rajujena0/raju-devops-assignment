# Challenges & Resolutions

## 1. t2.micro Not Free Tier Eligible in ap-south-2

**Problem:** Initial Terraform config used t2.micro (standard free tier). Apply failed with:
InvalidParameterCombination: The specified instance type is not eligible for Free Tier

**Resolution:** Queried eligible types for the region:
```bash
aws ec2 describe-instance-types \
  --region ap-south-2 \
  --filters Name=free-tier-eligible,Values=true \
  --query "InstanceTypes[*].InstanceType"
```
Result: `t3.micro` is free tier eligible in ap-south-2. Updated `variables.tf` default accordingly.

---

## 2. RDS Backup Retention Limit on Free Tier

**Problem:** Apply failed with:
FreeTierRestrictionError: The specified backup retention period exceeds the maximum available to free tier customers

**Resolution:** Set `backup_retention_period = 0` in `rds.tf`. Noted in README that this should be set to 7 in production.

---

## 3. RDS Password with Special Characters Rejected

**Problem:** Initial password `DevOps@Pass123!` caused:
InvalidParameterValue: The parameter MasterUserPassword is not a valid password.
Only printable ASCII characters besides '/', '@', '"', ' ' may be used.

**Resolution:** Removed `@` from password. Updated `terraform.tfvars.local` with `DevOpsPass123!`.

---

## 4. DynamoDB State Lock Stuck After Failed Plan

**Problem:** After a failed `terraform plan`, DynamoDB retained the lock. Subsequent runs failed with:
Error acquiring the state lock: ConditionalCheckFailedException

**Resolution:** Used `terraform force-unlock` with the lock ID from the error message:
```bash
terraform force-unlock 2a22037c-bf52-5553-90ee-9543f69006f2
```

---

## 5. WSL PATH Conflict with Jest

**Problem:** Running `npm test` in WSL executed Windows Jest binary instead of Linux one, causing:
Error: Could not find a config file based on provided values: path: "C:\Windows"

**Resolution:** Invoked Jest directly via Node to bypass PATH resolution:
```bash
node node_modules/jest/bin/jest.js --coverage --forceExit
```
Updated `package.json` test script accordingly.

---

## 6. node_modules Accidentally Pushed to GitHub

**Problem:** First `git push` included `node_modules/` directory — 5711 objects, 6.4MB.

**Resolution:**
```bash
echo "app/node_modules/" >> .gitignore
git rm -r --cached app/node_modules/
git commit -m "fix: remove node_modules from tracking"
```
Subsequent push was 504 bytes.

---

## 7. S3 Bucket Creation Required LocationConstraint Outside us-east-1

**Problem:** Standard `aws s3api create-bucket` command failed for ap-south-2 region.

**Resolution:** Added `--create-bucket-configuration LocationConstraint=ap-south-2` flag:
```bash
aws s3api create-bucket \
  --bucket devops-assignment-tfstate-118688039965 \
  --region ap-south-2 \
  --create-bucket-configuration LocationConstraint=ap-south-2
```

---

## 8. Docker Compose Plugin Not in Default Ubuntu Repo

**Problem:** `sudo apt install docker-compose-plugin` failed — package not found in default Ubuntu repos.

**Resolution:** Added Docker's official apt repository then installed:
```bash
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /etc/apt/keyrings/docker.gpg
sudo apt-get update && sudo apt-get install -y docker-compose-plugin
```
