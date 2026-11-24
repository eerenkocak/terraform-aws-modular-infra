# 🏗️ Modular AWS 3-Tier Cloud Infrastructure & Multi-Environment Orchestration (Terraform)

[🌍 English Documentation](#english-version) | [🇹🇷 Türkçe Dökümantasyon](#türkçe-versiyon)

---

## <a name="english-version"></a>🇺🇸 English Version

This repository demonstrates an enterprise-grade, **DRY (Don't Repeat Yourself)** **Infrastructure as Code (IaC)** architecture built with **Terraform** on **AWS (`eu-north-1`)**. Rather than flat configuration files, the infrastructure is encapsulated into reusable custom modules (`networking`, `compute`, `database`) and orchestrated across isolated **Development (`dev`)** and **Production (`prod`)** environments with dedicated remote states.

### 🚀 Key Architectural & DevOps Practices

* **Reusable Custom Modules (`modules/`):** Encapsulates core infrastructure domains into decoupled, parameterized building blocks (`networking`, `compute`, `database`) to enforce consistency and eliminate code duplication across environments.
* **Multi-Environment State Isolation (`environments/`):** Segregates `dev` (`10.10.0.0/16`) and `prod` (`10.20.0.0/16`) lifecycles. Each environment maintains its own variable definitions (`terraform.tfvars`) and isolated remote state path within **AWS S3**, protected against concurrent runs via **DynamoDB State Locking (`LockID`)**.
* **3-Tier Air-Gapped Network & S3 VPC Endpoint:** Provisions Public DMZ, Private App, and isolated Multi-AZ Database subnets with zero internet/NAT routing, paired with an **S3 Gateway VPC Endpoint** to route internal S3 traffic over the private AWS backbone at zero NAT processing cost.
* **Managed PostgreSQL RDS & FinOps Guardrails:** Deploys encrypted PostgreSQL RDS instances (`multi_az = true` in `prod`, `false` in `dev`) with strict storage autoscaling caps, Terraform variable `validation` checks, EC2 `cpu_credits = "standard"` limits, and mandatory **IMDSv2** hardening.
* **Zero-Trust Security Groups:** Enforces strict least-privilege firewall rules using Security Group ID referencing across tiers.

### 📐 Project Structure
```text
terraform-modular-aws-architecture/
├── modules/
│   ├── networking/          # Reusable 3-Tier VPC, Subnets, NAT GW & S3 VPC Endpoint
│   │   ├── main.tf
│   │   ├── variables.tf
│   │   └── outputs.tf
│   ├── compute/             # Zero-Trust SGs & Hardened EC2 Instances (FinOps + IMDSv2)
│   │   ├── main.tf
│   │   ├── variables.tf
│   │   └── outputs.tf
│   └── database/            # Isolated Multi-AZ PostgreSQL RDS Tier
│       ├── main.tf
│       ├── variables.tf
│       └── outputs.tf
├── environments/
│   ├── dev/                 # Isolated Development Workspace (10.10.0.0/16)
│   │   ├── main.tf
│   │   ├── variables.tf
│   │   ├── outputs.tf
│   │   └── terraform.tfvars
│   └── prod/                # Isolated Production Workspace (10.20.0.0/16, Multi-AZ)
│       ├── main.tf
│       ├── variables.tf
│       ├── outputs.tf
│       └── terraform.tfvars
├── .gitignore
└── README.md
```

### ⚙️ Deployment Lifecycle

#### 1. Format & Validate Across All Modules
```bash
terraform fmt -recursive
```

#### 2. Deploy Development Environment (`dev`)
```bash
cd environments/dev
terraform init
terraform validate
export TF_VAR_db_password="YourStrongDevPassword2026"
terraform plan
terraform apply -auto-approve
```

#### 3. Deploy Production Environment (`prod`)
```bash
cd ../prod
terraform init
terraform validate
export TF_VAR_db_password="YourStrongProdPassword2026"
terraform plan
terraform apply -auto-approve
```

---

## <a name="türkçe-versiyon"></a>🇹🇷 Türkçe Versiyon

Bu depo, **AWS (`eu-north-1`)** üzerinde **Terraform** kullanılarak **DRY (Kendini Tekrar Etme)** prensibine uygun olarak geliştirilmiş kurumsal standartlarda bir **Modüler Kod Olarak Altyapı (IaC)** mimarisidir. Düz dosya yığınları yerine yeniden kullanılabilir özel modüller (`networking`, `compute`, `database`) tasarlanmış ve bu modüller birbirinden tamamen izole **Geliştirme (`dev`)** ile **Canlı (`prod`)** ortamlarında ayrı uzak durum (Remote State) dosyalarıyla orkestre edilmiştir.

### 🚀 Öne Çıkan Bulut ve DevOps Pratikleri

* **Yeniden Kullanılabilir Modüler Mimari (`modules/`):** Altyapı bileşenleri (`networking`, `compute`, `database`) dışarıdan parametre alan bağımsız modüllere bölünerek kod tekrarı önlenmiş ve ölçeklenebilirlik sağlanmıştır.
* **Çoklu Ortam İzolasyonu (`environments/`):** Geliştirme (`10.10.0.0/16`) ve Canlı (`10.20.0.0/16`) ortamları birbirinden ayrılmıştır. Her ortam kendi `terraform.tfvars` ayarlarına ve **AWS S3** üzerinde kendi izole `.tfstate` yoluna sahiptir; eşzamanlı ekip çakışmaları **DynamoDB (`LockID`)** kilidi ile engellenir.
* **3 Katmanlı İzole Ağ & S3 VPC Endpoint:** Public DMZ, Private App ve internet/NAT çıkışı dahi kapalı Multi-AZ veritabanı alt ağları kurulmuş; iç S3 trafiğinin NAT Gateway maliyeti oluşturmadan AWS omurgasından akması için **S3 Gateway VPC Endpoint** entegre edilmiştir.
* **Yönetilen PostgreSQL RDS & FinOps Korumaları:** Canlı ortamda yüksek erişilebilirlik (`multi_az = true`), geliştirme ortamında maliyet optimizasyonu (`multi_az = false`) sunan şifreli RDS katmanı, Terraform `validation` limitleri, EC2 `cpu_credits = "standard"` sınırı ve **IMDSv2** güvenlik sertleştirmesi uygulanmıştır.
* **Sıfır Güven (Zero-Trust) Güvenlik Duvarları:** Katmanlar arası trafik yalnızca güvenlik grubu kimlikleri (Security Group ID) üzerinden sınırlandırılmıştır.

### ⚙️ Kurulum ve Yaşam Döngüsü

#### 1. Tüm Modülleri Formatlayın
```bash
terraform fmt -recursive
```

#### 2. Geliştirme Ortamını (`dev`) Canlıya Alın
```bash
cd environments/dev
terraform init
terraform validate
export TF_VAR_db_password="YourStrongDevPassword2026"
terraform plan
terraform apply -auto-approve
```

#### 3. Canlı Ortamı (`prod`) Canlıya Alın
```bash
cd ../prod
terraform init
terraform validate
export TF_VAR_db_password="YourStrongProdPassword2026"
terraform plan
terraform apply -auto-approve
```