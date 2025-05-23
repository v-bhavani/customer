resource "google_compute_disk" "data_disk" {
  for_each = {
    for disk in flatten([
      for vm in var.vms : [
        for disk in vm.disks : {
          key     = "${vm.name}-${disk.name}"
          vm_name = vm.name
          disk    = disk
          zone    = vm.zone
        }
      ]
    ]) : disk.key => disk
  }

  name = each.value.disk.name
  zone = each.value.zone
  size = each.value.disk.size_gb
  type = each.value.disk.type
}

# Create static IP addresses for each VM
resource "google_compute_address" "static_ip" {
  for_each = { for vm in var.vms : vm.name => vm }
  name     = "${each.value.name}-static-ip"
  region   = substr(each.value.zone, 0, length(each.value.zone) - 2)  # Extract region from zone
  project  = var.project_id
}

resource "google_compute_instance" "vm_instance" {
  for_each     = { for vm in var.vms : vm.name => vm }
  name         = each.value.name
  machine_type = each.value.machine_type
  zone         = each.value.zone

  boot_disk {
    initialize_params {
      image = var.snapshot_image
    }
  }

  network_interface {
    network    = var.network_name
    subnetwork = var.subnet_name
    network_ip = each.value.private_ip

    access_config {
      nat_ip = google_compute_address.static_ip[each.key].address
    }
  }

  dynamic "attached_disk" {
    for_each = { for disk in each.value.disks : disk.name => disk }
    content {
      source      = google_compute_disk.data_disk["${each.value.name}-${attached_disk.key}"].self_link
      device_name = attached_disk.value.name
    }
  }

  service_account {
    email  = var.service_account_email
    scopes = ["https://www.googleapis.com/auth/cloud-platform"]
  }

  tags = var.tags
}
