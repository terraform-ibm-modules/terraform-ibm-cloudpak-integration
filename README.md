# IBM Cloud Pak for Integration - Terraform Module

This is a module and example to make it easier to provision Cloud Pak for Integration on an IBM Cloud Platform OpenShift Cluster provisioned on either Classic or VPC infrastructure.  The cluster is required to contain at least 4 nodes of size 16x64. If VPC is used, Portworx™ is required to provide necessary storage classes.

## Compatibility

This module is meant for use with Terraform 0.13 (and higher).

## Usage

A full example is in the [examples](./examples/cp4i) folder.

e.g:

```hcl
provider "ibm" {
}

data "ibm_resource_group" "group" {
  name = var.resource_group_name
}

// Make directory to store cluster config
resource "null_resource" "mkdir_kubeconfig_dir" {
  triggers = { always_run = timestamp() }
  provisioner "local-exec" {
    command = "mkdir -p ${local.kube_config_path}"
  }
}

// Pull down the cluster configuration
data "ibm_container_cluster_config" "cluster_config" {
  depends_on = [null_resource.mkdir_kubeconfig_dir]
  cluster_name_id   = var.cluster_id
  resource_group_id = data.ibm_resource_group.group.id
  config_dir        = local.kube_config_path
}

// Cloud Pak for Integration module
module "cp4i" {
  source = "../.."
  enable = true

  // ROKS cluster parameters:
  cluster_config_path = data.ibm_container_cluster_config.cluster_config.config_file_path
  storageclass        = "ibmc-file-gold-gid"

  // Entitled Registry parameters:
  entitled_registry_key        = "<entitlement_key>"
  entitled_registry_user_email = "<entitlement_email>"

  namespace           = "cp4i"
}

```

## Requirements

### Terraform plugins

- [Terraform](https://www.terraform.io/downloads.html) 0.13 (or later)
- [terraform-provider-ibm](https://github.com/IBM-Cloud/terraform-provider-ibm) 1.34 (or later)

## Install

### Terraform

Be sure you have the correct Terraform version (0.13), you can choose the binary here:

- [terraform-provider-ibm](https://github.com/IBM-Cloud/terraform-provider-ibm/releases) 1.34 (or later)
- [Terraform](https://releases.hashicorp.com/terraform/) 0.13 (or later)

For installation instructions, refer [here](https://ibm.github.io/cloud-enterprise-examples/iac/setup-environment/#install-terraform)

### Pre-commit hooks

Run the following command to execute the pre-commit hooks defined in .pre-commit-config.yaml file

```bash
pre-commit run -a
```

You can install pre-coomit tool using

```bash
pip install pre-commit
```

or

```bash
pip3 install pre-commit
```

### Detect Secret hook

Used to detect secrets within a code base.

To create a secret baseline file run following command

```bash
detect-secrets scan --update .secrets.baseline
```

While running the pre-commit hook, if you encounter an error like

```console
WARNING: You are running an outdated version of detect-secrets.
Your version: 0.13.1+ibm.27.dss
Latest version: 0.13.1+ibm.46.dss
See upgrade guide at https://ibm.biz/detect-secrets-how-to-upgrade
```

run below command

```bash
pre-commit autoupdate
```

which upgrades all the pre-commit hooks present in .pre-commit.yaml file.

## How to input variable values through a file

To review the plan for the configuration defined (no resources actually provisioned)

```bash
terraform plan -var-file=./input.tfvars
```

To execute and start building the configuration defined in the plan (provisions resources)

```bash
terraform apply -var-file=./input.tfvars
```

To destroy the VPC and all related resources

```bash
terraform destroy -var-file=./input.tfvars
```

## Note

All optional parameters, by default, will be set to `null` in respective example's variable.tf file. You can also override these optional parameters.
