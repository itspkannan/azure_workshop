# Installation Instruction

## Azure Secure VPC + Load Balancer + RBAC Deployment Guide

This guide walks you through deploying a secure Azure infrastructure with:
- Public & Private VNets
- Load Balancer to expose only port 80
- Network Security Group rules
- Custom RBAC Roles (Admin, Deployer, Developer)

```mermaid
---
config:
  layout: elk
---
flowchart TD
 subgraph PublicVNet["VNet: Public (10.0.0.0/16)"]
        lbsubnet["Subnet: subnet-lb (10.0.1.0/24)"]:::publicvnet
        lb["Azure Load Balancer"]:::publicvnet
        lbip["Public IP"]:::publicvnet
  end
 subgraph PrivateVNet["VNet: Private (10.1.0.0/16)"]
        appsubnet["Subnet: subnet-app (10.1.1.0/24)"]:::privatevnet
        appvm["App VM / Container Instance"]:::privatevnet
        appnsg["NSG: Allow HTTP from LB Only"]:::privatevnet
  end
 subgraph IAM["Azure RBAC"]
        admin["Admin Role<br>(Full Access)"]:::rbac
        deployer["Deployer Role<br>(Create, No Delete)"]:::rbac
        developer["Developer Role<br>(App Deploy Only)"]:::rbac
  end
    lb -- HTTP port 80 --> lbip
    appsubnet --> appvm & appnsg
    internet["🌐 Internet"] -- HTTP --> lbip
    lbip --> lb
    lb -- Forward HTTP --> appvm
    IAM --> azurerm["Azure Resource Group"]:::rbac
    azurerm -.-> lb & appvm
    appnsg --> note1["Blocks all ingress <br>except port 80 from LB"]

    classDef publicvnet fill:#B2F7B8,stroke:#2E8B57,stroke-width:2px;
    classDef privatevnet fill:#B3D9FF,stroke:#0366d6,stroke-width:2px;
    classDef rbac fill:#ECD4FF,stroke:#892CDC,stroke-width:2px;

```


### Prerequisites

- Azure CLI (`az`)
- Terraform ≥ v1.3+
- Logged in to Azure:  
  
```bash
  az login
````

### Directory Structure

```bash
.
├── main.tf
├── modules/
│   ├── networking/
│   ├── nsg/
│   ├── load_balancer/
│   └── roles/

```

### 🔧 Step-by-Step Installation

The makefile has all the terraform command to create the necessary infrastructure. 


#### 1. Initialize Terraform

```bash

make terraform.init

```
The command that is executed is `terraform init`

![init](docs/images/terraform_init.gif)

#### 2. Plan the Deployment


```bash

make terraform.plan 

```

The command that is executed is `terraform plan`


![init](docs/images/terraform_plan.gif)

#### 3. Apply the Deployment

```bash

make terraform.apply 

```

The command that is executed is `terraform apply -auto-approve`


![init](docs/images/terraform_apply.gif)

#### 4. View Outputs

```bash

make terraform.output 

```

The command that is executed is `terraform output`

![init](docs/images/terraform_output.gif)

Expected outputs:

* `public_subnet_id`
* `private_subnet_id`
* `resource_group`


### Role Descriptions [ For this excercise not implemented - Need to create separate user associated to this role on Entra]

| Role      | Actions Allowed                                     |
| --------- | --------------------------------------------------- |
| Admin     | Full access (use built-in `Owner` or `Contributor`) |
| Deployer  | Can create/update but **not delete** infrastructure |
| Developer | Can deploy code to existing services only           |


### Access

* Load Balancer will expose only **port 80**
* Private subnet blocks all ingress except via Load Balancer IP

