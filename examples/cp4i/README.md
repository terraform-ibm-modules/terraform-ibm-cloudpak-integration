# Module cloudpak-integration
This example provisions the cloudpak-integration module to install Cloud Pak for Integration on an IBM Cloud Platform OpenShift Cluster provisioned on either Classic or VPC infrastructure.  The cluster is required to contain at least 4 nodes of size 16x64. If VPC is used on OpenShift 4.6 or earlier, Portworx™ is required to provide necessary storage classes. If VPC is used on OpenShift 4.7 or later, ODF is required to provide necessary storage classes.

## Inputs

| Name                               | Description  | Default                     | Required |
| ---------------------------------- | ----- | --------------------------- | -------- |
| `cluster_id`                       | ID of the cluster to install cloud pak on. Cluster needs to be at least 4 nodes of size 16x64.|                             | Yes       |
| `resource_group`                   | Resource Group in your account to host the cluster. List all available resource groups with: `ibmcloud resource groups`     | `Default`         | No       |
| `storageclass`                   | Storage class to be used: Defaulted to `ibmc-file-gold-gid` for Classic Infrastructure. If using a VPC cluster, set to `portworx-rwx-gp3-sc` and make sure Portworx is set up on cluster  | `ibmc-file-gold-gid`         | No       |
| `entitled_registry_key`            | Get the entitlement key from https://myibm.ibm.com/products-services/containerlibrary.   |                             | Yes      |
| `entitled_registry_user_email`     | Email address of the user owner of the Entitled Registry Key   |                             | Yes      |

If running locally, set the desired values for these variables in the `input.tfvars` file.  Here are some examples:

```hcl
  cluster_id            = "******************"
  storageclass          = "ibmc-file-gold-gid"
  resource_group_name   = "Default"
  entitled_registry_key = "******************"
  entitled_registry_user_email = "john.doe@email.com"
```

## Outputs

| Name                               | Description |
| ---------------------------------- | -----
| `endpoint`                       | Public URL to get to Cloud Pak for Integration Dashboard
| `user`                   | Admin User Id for dashboard
| `password`                   | Password for dashboard.  Be sure to reset after initial log in

### Execute the example

Execute the following Terraform commands:

```bash
terraform init
terraform plan
terraform apply -auto-approve
```

### Verify

To verify installation on the cluster, go to the `Installed Operators` tab on the Openshift console. Choose your `namespace` and click on `IBM Cloud Pak for Integration Platform Navigator 4.2.0 provided by IBM` . Click on the `Platform Navigator` tab. Check the status of the `cp4i-navigator`.

### Cleanup

Go into the console and delete the platform navigator from the verify section. Delete all installed operators and lastly delete the project.

Finally, execute: `terraform destroy`.

If running locally, there are some directories and files you may want to manually delete, these are: `rm -rf terraform.tfstate* .terraform .kube`.
