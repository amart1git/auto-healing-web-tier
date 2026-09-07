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

