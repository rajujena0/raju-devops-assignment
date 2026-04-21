# Approach Document

## Architecture Decisions

### Infrastructure (Terraform)
- **Remote State on S3 + DynamoDB** — prevents state corruption in team environments through file locking
- **Public/Private subnet split** — ALB in public subnets, EC2 and RDS in private subnets; nothing sensitive is internet-accessible
- **Single NAT Gateway** — cost-conscious choice for assignment; production would use one per AZ for HA
- **t3.micro for EC2, db.t3.micro for RDS** — free tier eligible in ap-south-2 region
- **IAM Instance Profile on EC2** — no long-lived access keys on the server; EC2 pulls secrets via role
- **Encrypted RDS storage** — storage_encrypted = true even for assignment to show security mindset
- **Default tags via provider** — every resource tagged with Project, Environment, ManagedBy automatically

### CI/CD (GitHub Actions)
- **GitHub Actions over Jenkins** — zero infrastructure to maintain; native GitHub integration
- **Three separate workflows** — pr-checks, deploy-staging, deploy-prod — clear separation of concerns
- **Docker image tagged with git SHA** — every image is traceable back to exact commit
- **Trivy vulnerability scan** — scans container image in CI before it ever reaches staging
- **Manual approval gate for production** — uses GitHub Environments with required reviewers
- **SSM for deployment** — no SSH keys needed; EC2 accessed securely via IAM role

### Application
- **Node.js + Express** — lightweight, fast, easy to containerise
- **Multi-stage Dockerfile** — builder stage for deps, runtime stage for final image; smaller image size
- **Non-root user in container** — security best practice; app runs as appuser not root
- **HEALTHCHECK in Dockerfile** — container orchestrators can detect unhealthy containers automatically
- **93% test coverage** — unit + integration tests using Jest and Supertest

### Monitoring
- **Prometheus + Grafana + Loki** — open source, portable, industry standard observability stack
- **Node Exporter** — exposes infrastructure metrics (CPU, memory, disk) to Prometheus
- **Loki for logs** — lightweight log aggregation; integrates natively with Grafana
- **Two dashboards** — Infrastructure (CPU/memory/disk) and Application (containers, health)
- **Docker Compose** — reproducible local setup; same config works on any server

### Security
- **AWS Secrets Manager** — DB password stored and retrieved securely; never in code or environment files
- **Security group chaining** — ALB SG → App SG → DB SG; database only reachable from app layer
- **GitHub Secrets** — AWS credentials stored encrypted; never in workflow files
- **.gitignore** — tfvars, node_modules, coverage excluded from version control
