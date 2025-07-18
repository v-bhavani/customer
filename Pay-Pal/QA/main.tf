
provider "google" {
  project = var.project_id
  region  = var.region
 # impersonate_service_account = "test-auth-symphony@sapspecific.iam.gserviceaccount.com"
}

terraform {
  backend "gcs" {
    bucket = "bcs_terraform_bucket"
    prefix = "paypal/qa"
  #  impersonate_service_account = "test-auth-symphony@sapspecific.iam.gserviceaccount.com"
  }
}

module "snapshot" {
  source        = "./modules/snapshot"
  project_id    = var.project_id
  snapshot_name = var.snapshot_name
}

module "vm_and_disk" {
  source                = "./modules/vm_and_disk"
  vms                   = var.vms
  project_id            = var.project_id
  network_name          = var.network_name
  subnet_name           = var.subnet_name
  service_account_email = var.service_account_email
  tags                  = var.tags
  snapshot_image        = module.snapshot.image_id
}
