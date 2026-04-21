const express = require('express');
const path = require('path');
const app = express();
const PORT = process.env.PORT || 8080;

app.use(express.static(path.join(__dirname, 'public')));
app.use(express.json());

const profile = {
  name: "Raju Jena",
  title: "Cloud DevOps & Site Reliability Engineer",
  location: "Navi Mumbai, India",
  email: "jenaraju13@gmail.com",
  stats: [
    { label: "Uptime Achieved", value: "99.9%" },
    { label: "Deployment Time Cut", value: "70%" },
    { label: "Manual Toil Eliminated", value: "85%" },
    { label: "MTTR Reduction", value: "40%" }
  ],
  skills: {
    "Cloud Platforms": ["AWS (EC2, EKS, Lambda, RDS, S3)", "Azure", "GCP"],
    "Containers & Orchestration": ["Docker", "Kubernetes (EKS)", "Helm", "HPA"],
    "IaC & Automation": ["Terraform", "CloudFormation", "Ansible", "Python", "Bash"],
    "CI/CD & DevSecOps": ["GitLab CI/CD", "Jenkins", "Git", "SonarQube"],
    "Observability": ["Dynatrace", "ELK Stack", "CloudWatch", "Prometheus", "Grafana"],
    "SRE Practices": ["Incident Management", "On-call", "SLIs/SLOs", "Post-Mortems"]
  },
  experience: [
    {
      role: "Cloud DevOps / Site Reliability Engineer",
      company: "ApMoSys Technology",
      location: "Navi Mumbai",
      period: "Dec 2023 – Apr 2026",
      highlights: [
        "Achieved 99.9% uptime through multi-AZ redundancy and auto-scaling",
        "Reduced MTTR by 40% using Prometheus, Grafana, CloudWatch and ELK",
        "Cut deployment time by 70% with GitLab CI/CD and Jenkins automation",
        "Eliminated 85% of manual provisioning using Terraform and CloudFormation",
        "Managed Kubernetes (EKS) with HPA for zero-downtime deployments",
        "Built Python/Bash automation eliminating 90% of repetitive tasks"
      ]
    },
    {
      role: "Cloud Consultant Intern",
      company: "Cognifyz Technologies",
      location: "Remote",
      period: "May 2023 – Nov 2023",
      highlights: [
        "Supported monitoring and incident resolution using AWS CloudWatch",
        "Assisted in CI/CD pipeline builds with GitLab and Jenkins"
      ]
    }
  ],
  projects: [
    { name: "CRCS Refund Portal", tech: ["AWS", "ELK", "CloudWatch"], description: "Government payment portal handling 200K+ concurrent users with near-zero downtime" },
    { name: "Punjab Tirth Yatra", tech: ["Kubernetes", "Helm", "HPA"], description: "Elastic scaling under variable traffic with zero manual intervention" },
    { name: "Mahindra Car Lease Hub", tech: ["GitLab CI/CD", "Jenkins", "Terraform"], description: "Reduced deployment cycle time by 65%, enabling same-day feature releases" }
  ],
  certifications: ["OCI DevOps Professional", "GitLab Solutions Architect Associate"],
  education: { degree: "Master of Computer Applications (MCA)", institution: "GIET University", gpa: "8.3 / 10.0" }
};

app.get('/health', (req, res) => {
  res.status(200).json({ status: 'healthy', timestamp: new Date().toISOString() });
});

app.get('/api/profile', (req, res) => {
  res.status(200).json(profile);
});

app.get('/', (req, res) => {
  res.sendFile(path.join(__dirname, 'public', 'index.html'));
});

app.listen(PORT, () => {
  console.log(`Portfolio server running on port ${PORT}`);
});

module.exports = app;
