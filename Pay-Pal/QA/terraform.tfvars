project_id           = "sapspecific" #qa
region               = "us-central1"
network_name         = "pay-pal"
subnet_name          = "pay-subnet"
service_account_email = "forsymphony@sapspecific.iam.gserviceaccount.com"
snapshot_name        = "pay-pal-golden-snap-v1"
tags = ["web", "production"]
vms = [
  {
    name         = "qa-s4hana-dahpaydb"
    machine_type = "e2-standard-8"
    zone         = "us-central1-a"
    private_ip   = "10.0.0.18"
    disks = [
      {
        name    = "qa-s4hana-dahpaydb-backup"
        size_gb = 100
        type    = "pd-standard"
      },
      {
        name    = "qa-s4hana-dahpaydb-shared"
        size_gb = 64
        type    = "pd-standard"
      },
      {
        name    = "qa-s4hana-dahpaydb-data"
        size_gb = 64
        type    = "pd-standard"
      },
      {
        name    = "qa-s4hana-dahpaydb-log"
        size_gb = 50
        type    = "pd-standard"
      }
    ]
  },
  {
    name         = "qa-dahpay01db"
    machine_type = "e2-standard-8"
    zone         = "us-central1-a"
    private_ip   = "10.0.0.19"
    disks = []
  },
  {
    name         = "qa-dahpay02db"
    machine_type = "e2-standard-8"
    zone         = "us-central1-a"
    private_ip   = "10.0.0.20"
    disks = []
  },
  {
    name         = "qa-s4hana-dahpaypapp"
    machine_type = "e2-standard-8"
    zone         = "us-central1-a"
    private_ip   = "10.0.0.21"
    disks = [
      {
        name    = "qa-s4hana-dahpaypapp-usrsap"
        size_gb = 20
        type    = "pd-standard"
      },
      {
        name    = "qa-s4hana-dahpaypapp-sapmnt"
        size_gb = 15
        type    = "pd-standard"
      },
      {
        name    = "qa-s4hana-dahpaypapp-softdump"
        size_gb = 64
        type    = "pd-standard"
      }
    ]
  }
]

