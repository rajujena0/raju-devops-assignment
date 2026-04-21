# DevOps Assignment — Raju Jena

A complete end-to-end DevOps implementation on AWS featuring Infrastructure as Code, CI/CD automation, and observability.

## Architecture Overview
Internet → ALB (public subnets) → EC2 App Server (private subnets) → RDS PostgreSQL (private subnets)
↑
GitHub Actions CI/CD
↑
Prometheus + Grafana + Loki

## Tech Stack

| Layer | Technology |
|---|---|
| Infrastructure | Terraform, AWS (VPC, EC2, RDS, ALB, ECR, IAM) |
| Application | Node.js, Express, Docker |
| CI/CD | GitHub Actions |
| Monitoring | Prometheus, Grafana, Loki, Node Exporter |
| Secret Management | AWS Secrets Manager |

## Repository Structure
devops-assignment/
├── terraform/          # Infrastructure as Code
├── app/                # Portfolio web application
│   ├── src/
│   └── Dockerfile
├── .github/workflows/  # CI/CD pipelines
│   ├── pr-checks.yml
│   ├── deploy-staging.yml
│   └── deploy-prod.yml
├── monitoring/         # Observability stack
│   ├── docker-compose.yml
│   ├── prometheus.yml
│   └── grafana/
└── scripts/
└── backup.sh

## Part 1: Infrastructure Setup

### Prerequisites
- AWS CLI configured (`aws configure`)
- Terraform >= 1.5.0
- An AWS account with appropriate permissions

### Steps

```bash
# 1. Create S3 bucket for remote state
aws s3api create-bucket \
  --bucket devops-assignment-tfstate-<ACCOUNT_ID> \
  --region ap-south-2 \
  --create-bucket-configuration LocationConstraint=ap-south-2

# 2. Create DynamoDB table for state locking
aws dynamodb create-table \
  --table-name terraform-state-lock \
  --attribute-definitions AttributeName=LockID,AttributeType=S \
  --key-schema AttributeName=LockID,KeyType=HASH \
  --billing-mode PAY_PER_REQUEST \
  --region ap-south-2

# 3. Initialize and apply Terraform
cd terraform
terraform init
terraform apply -var="db_password=<YOUR_PASSWORD>"
```

### Infrastructure Created
- VPC with 2 public + 2 private subnets across 2 AZs
- EC2 t3.micro in private subnet (free tier)
- RDS PostgreSQL db.t3.micro in private subnet (free tier)
- Application Load Balancer in public subnets
- Security groups with least-privilege rules
- IAM roles for EC2 (SSM, ECR, Secrets Manager access)
- S3 backend + DynamoDB state locking

## Part 2: CI/CD Pipeline

Three GitHub Actions workflows:

| Workflow | Trigger | Jobs |
|---|---|---|
| pr-checks.yml | Pull Request → main | Test, npm audit |
| deploy-staging.yml | Push → main | Test, Build, Push ECR, Deploy via SSM |
| deploy-prod.yml | Staging success | Manual approval → Deploy to prod |

### Required GitHub Secrets
AWS_ACCESS_KEY_ID
AWS_SECRET_ACCESS_KEY

### Pipeline Flow
PR Created → Tests + Vulnerability Scan
↓
Merge to main → Build Docker Image → Push to ECR → Trivy Scan → Deploy Staging
↓
Manual Approval (production environment) → Deploy Production

## Part 3: Monitoring & Logging

### Start Monitoring Stack
```bash
cd monitoring
sudo docker compose up -d prometheus grafana loki node-exporter
```

### Access Dashboards
| Service | URL | Credentials |
|---|---|---|
| Grafana | http://localhost:3000 | admin / DevOps@2024 |
| Prometheus | http://localhost:9090 | - |
| Loki | http://localhost:3100 | - |

### Metrics Collected
- **Infrastructure:** CPU, memory, disk via Node Exporter
- **Application:** Container metrics via cAdvisor
- **Database:** PostgreSQL metrics via postgres-exporter
- **Logs:** App + system logs via Promtail → Loki

### Dashboards
1. **Infrastructure Dashboard** — CPU %, memory %, disk usage with thresholds
2. **Application Dashboard** — container count, CPU/memory per container, app health

## Part 4: Security Considerations

- **No hardcoded secrets** — all credentials in AWS Secrets Manager + GitHub Secrets
- **Private subnets** — EC2 and RDS not publicly accessible
- **Security groups** — least privilege (ALB → App → DB chain only)
- **IAM roles** — EC2 uses instance profile, no long-lived access keys on server
- **Encrypted storage** — RDS storage encrypted at rest
- **Container security** — Docker image runs as non-root user
- **Vulnerability scanning** — Trivy scans every Docker image in CI pipeline

## Cost Optimization

- EC2 t3.micro + RDS db.t3.micro — free tier eligible
- Single NAT Gateway instead of one per AZ (~$32/mo saved)
- `terraform destroy` when not in use
- RDS backup retention set to 0 (free tier restriction)
- S3 remote state with versioning — minimal cost (~$0.001/mo)

## Secret Management

DB password stored in AWS Secrets Manager:
```bash
aws secretsmanager get-secret-value \
  --secret-id "devops-assignment/db-password" \
  --region ap-south-2
```

## Backup Strategy

Automated RDS snapshots via `scripts/backup.sh`:
- Daily snapshots with date-stamped IDs
- 7-day retention with automatic cleanup
- Run via cron: `0 2 * * * /path/to/backup.sh`

## Challenges & Resolutions

| Challenge | Resolution |
|---|---|
| t2.micro not free tier in ap-south-2 | Switched to t3.micro after querying eligible types |
| RDS backup retention limit on free tier | Set backup_retention_period = 0 |
| RDS password with @ not allowed | Removed special characters from password |
| DynamoDB state lock stuck after failed plan | Used terraform force-unlock with lock ID |
| WSL PATH conflict running Jest | Used node_modules/.bin/jest directly |
| node_modules pushed to GitHub | Added to .gitignore and removed from tracking |
