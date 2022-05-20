provider "google" {
  project = var.project
  region  = var.region
  zone    = var.zone

}

resource "google_compute_network" "vpc_network" {
  name = "terraform-network"
}
