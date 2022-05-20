provider "google" {
  project = var.project
  region  = var.region
  zone    = var.zone
}

resource "google_compute_network" "vpc_network" {
  name = "terraform-vpcnetwork"
}

//database
resource "google_sql_database_instance" "database" {
  name = "db-test"
  database_version = "POSTGRES_11"
  region = "us-central1"
  
  settings {
    tier = "db-f1-micro"
  }
  deletion_protection = false
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
    service_account = google_service_account.default.email
    oauth_scopes = [
      "https://www.googleapis.com/auth/cloud-platform"
    ]
  }
}

