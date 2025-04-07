# Gym Log App – Proof of Concept

A full-stack monolithic application for tracking workouts, built with modern tools and designed for future scalability. This POC supports multiple interfaces including web, mobile, and a smart mirror, with backend APIs and infrastructure provisioned using Terraform on AWS.

## Tech Stack

### Frontend

- [Next.js](https://nextjs.org/) – Web UI
- [Tailwind CSS](https://tailwindcss.com/) – Styling

### Backend

- [Node.js](https://nodejs.org/) or [Deno](https://deno.com/) – API layer
- [PostgreSQL](https://www.postgresql.org/) – Primary database
- [Prisma](https://www.prisma.io/) or [Drizzle ORM](https://orm.drizzle.team/) – DB toolkit

### Infra

- [Terraform](https://www.terraform.io/) – Infrastructure as Code
- AWS Services:
  - Lambda
  - RDS (PostgreSQL)
  - API Gateway
  - Cognito
  - S3
  - CloudFront

## 🛠️ Getting Started

### Prerequisites

- Node.js / Deno installed
- Terraform CLI
- AWS CLI with credentials configured
- Docker (optional for local dev)

### Local Setup

```bash
# Install dependencies
npm install

# Start the web app (Next.js)
cd apps/web
npm run dev

#Infrastructure Setup (Dev)
cd infra/environments/dev
terraform init
terraform apply
```
