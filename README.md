\# Auto-Healing, N+1 Web Tier Infrastructure



\## Cloud Provider Choice \& Trade-offs

\*\*Selected Platform:\*\* AWS + Terraform (v1.6+)



\* \*\*Why AWS?\*\* AWS Auto Scaling Groups integrated directly with Application Load Balancer (ALB) health checks provide standard out-of-the-box target replacement with minimal latency.

\* \*\*Why Terraform?\*\* Declarative state management provides strict \*\*idempotency\*\* (self-provisioning). Executing a second run without configuration edits results in zero changes (`No changes`).



\---



\## Architecture Diagram



```text

                          \[ Internet Traffic ]

                                   │

                                   ▼

                        ┌─────────────────────┐

                        │  Internet Gateway   │

                        └──────────┬──────────┘

                                   │

                    ┌──────────────┴──────────────┐

                    │  Application Load Balancer  │

                    │  (Port 80 Ingress)          │

                    └──────────────┬──────────────┘

                                   │

               ┌───────────────────┴───────────────────┐

               │                                       │

               ▼ (AZ-a)                                ▼ (AZ-b)

┌───────────────────────────┐           ┌───────────────────────────┐

│ Public Subnet 10.0.0.0/24 │           │ Public Subnet 10.0.1.0/24 │

│                           │           │                           │

│   ┌───────────────────┐   │           │   ┌───────────────────┐   │

│   │ EC2 Instance (1)  │   │           │   │ EC2 Instance (2)  │   │

│   │  \[Docker Engine]  │   │           │   │  \[Docker Engine]  │   │

│   │  └─ NGINX Container│  │           │   │  └─ NGINX Container│  │

│   └───────────────────┘   │           │   └───────────────────┘   │

└───────────────────────────┘           └───────────────────────────┘

               ▲                                       ▲

               └──────── Auto Scaling Group ───────────┘

                         (Health Check: ELB)


\## Overview

auto-healing-web-tier/
├── .github/
│   └── workflows/
│       └── terraform-ci.yml      # CI Pipeline (lint / validate)
├── modules/
│   └── auto_healing_web/
│       ├── main.tf               # VPC, Subnets, ALB, Launch Template, ASG
│       ├── variables.tf          # Module inputs
│       └── outputs.tf            # ALB DNS output
├── Dockerfile                    # Containerization setup
├── main.tf                       # Provider configuration & module call
├── variables.tf                  # Root input variables
├── outputs.tf                    # Root outputs
└── README.md                     # Architecture, cost, choices & run guide



\## Key Technical Criteria Mapping

	Self-Healing & N+1 Capacity: The Auto Scaling Group (aws_autoscaling_group) maintains min_size = 2 and desired_capacity = 2 across two public subnets in different Availability Zones. 
	health_check_type = "ELB" ensures that if an HTTP health check fails or an instance is terminated, the ASG automatically replaces it without downtime.

	Self-Provisioning (IaC): Written strictly in modular Terraform (v1.6+). Declarative state management ensures that a second terraform apply results in No changes.

	Containerization: Includes a Dockerfile serving NGINX content. The EC2 Launch Template utilizes user_data (cloud-init) to install Docker and run the container image automatically on instance boot.

	Cost Estimation (≤ AUD 20/mo): AWS t3.micro instances qualify for Free Tier (750 hours/month combined). With an Application Load Balancer (~$16 USD) and gp3 EBS storage (~$1.28 USD), the estimated running cost sits at ~$17.28 USD (~AUD 26.50). 
	Optimization note: Switching to a Network Load Balancer (NLB) or t4g.nano ARM spot instances reduces running costs to < AUD 10.00/month.
