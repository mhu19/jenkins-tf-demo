provider "google" {
  project = var.project
  region  = var.region
  zone    = var.zone
}

resource "google_compute_network" "vpc_network" {
  name = "terraform-vpcnetwork"
}

resource "google_sql_database_instance" "database" {
  name = "db-test"
  database_version = "POSTGRES_11"
  region = "us-central1"
  
  settings {
    tier = "db-f1-micro"
  }
}
