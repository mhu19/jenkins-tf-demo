provider "google" {
  project = var.project
  region  = var.region
  zone    = var.zone
}

module "bastion_host" {
  source = "terraform-google-modules/bastion-host/google//modules/bastion-group"
  
  project = var.project
  region  = var.region
  zone    = var.zone
  
  network = google_compute_network.network.self_link
  subnet = google_compute_subnetwork.subnet.self_link
  members = ["jenkins-sa@crack-mix-350403.iam.gserviceaccount.com"]
}
  
resource "google_compute_network" "vpc_network" {
  name = "terraform-vpcnetwork"
  auto_create_subnetworks = false
}

resource "google_compute_subnetwork" "subnet" {
  name = "terraform-subnet"
  ip_cidr_range = "10.127.0.0/20
  network = google_compute_network.network.self_link
  private_ip_google_access = true
}

//database
resource "google_sql_database_instance" "main" {
  name = "db-test1"
  database_version = "POSTGRES_11"
  region = "us-central1"
  
  settings {
    tier = "db-f1-micro"
  }
  
}

resource "google_container_cluster" "primary" {
  name = "gke-cluster"
  location = "us-central1"
  remove_default_node_pool = true
  initial_node_count = 1
}
resource "google_container_node_pool" "primary_preemptible_nodes" {
  name = "node-pool"
  location =  "us-central1"
  cluster = google_container_cluster.primary.name
  node_count = 1
  
  node_config {
    preemptible = true
    machine_type = "e2-medium"
    service_account = "jenkins-sa@crack-mix-350403.iam.gserviceaccount.com"
    oauth_scopes = [
      "https://www.googleapis.com/auth/cloud-platform"
    ]
  }
}

  
  
