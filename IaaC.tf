# Configure the Google Cloud provider
provider "google" {
  credentials = file("auth.json")
  project     = "infrastructure-task"
  region      = "us-central1"
}

# Define a VPC network
resource "google_compute_network" "network" {
  name = "network"
}

# Define a subnetwork within the VPC
resource "google_compute_subnetwork" "subnetwork" {
  name          = "subnetwork"
  region        = "us-central1"
  network       = google_compute_network.my_network.name
  ip_cidr_range = "10.0.0.0/24"  # Adjust the IP range as needed
}

# Define a GKE cluster
resource "google_container_cluster" "test" {
  name               = "test"
  location           = "us-central1"
  initial_node_count = 1
  network            = google_compute_network.network.name
  subnetwork         = google_compute_subnetwork.subnetwork.name

  }

# Define a Cloud SQL instance (MySQL in this example)
resource "google_sql_database_instance" "sql_instance" {
  name             = "sql-instance"
  database_version = "MYSQL_8_0"
  region           = "us-central1"
  settings {
    tier = "db-f1-micro"
  }
}

# Define a database inside the Cloud SQL instance
resource "google_sql_database" "database" {
  name     = "database"
  instance = google_sql_database_instance.sql_instance.name
}

# Create a GCP firewall rule to allow VPN access
resource "google_compute_firewall" "vpn_firewall_rule" {
  name    = "allow-vpn-access"
  network = google_compute_network.network.name

  allow {
    protocol = "tcp"
    ports    = ["500", "4500"]
  }

  source_ranges = ["10.26.32.12/32", "19.104.105.29/32"]
}

# Create a GCP firewall rule to allow HTTP traffic from anywhere
resource "google_compute_firewall" "http_firewall_rule" {
  name    = "allow-http-traffic"
  network = google_compute_network.network.name

  allow {
    protocol = "tcp"
    ports    = ["80", "443"]
  }

  source_ranges = ["0.0.0.0/0"]
}

# Output the Kubernetes cluster and Cloud SQL instance information
output "cluster_endpoint" {
  value       = google_container_cluster.cluster.endpoint
  description = "Kubernetes cluster endpoint"
}

output "sql_instance_connection_name" {
  value       = google_sql_database_instance.sql_instance.connection_name
  description = "Cloud SQL instance connection name"
} 