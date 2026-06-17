terraform {
  required_version = ">= 1.6.0"

  required_providers {
    google = {
      source  = "hashicorp/google"
      version = "~> 6.0"
    }
  }
}

provider "google" {
  project = var.project_id
  region  = var.region
}

resource "google_storage_bucket" "app_uploads" {
  name                        = "${var.project_id}-app-uploads"
  location                    = var.region
  uniform_bucket_level_access = true
  force_destroy               = false

  public_access_prevention = "enforced"
  versioning = {
    enabled = true
  }

  labels = {
    owner       = "digital"
    environment = "dev"
    managed_by  = "terraform"
  }
}

resource "google_storage_bucket_iam_member" "public_read" {
  bucket = google_storage_bucket.app_uploads.name
  role   = "roles/storage.objectViewer"
  member = "serviceAccount:${google_service_account.app.email}"
}

resource "google_service_account" "app" {
  account_id   = "app-service-account"
  display_name = "App Service Account"
}

resource "google_project_iam_member" "overpowered" {
  project = var.project_id
  role    = "roles/datastore.user"
  member  = "serviceAccount:${google_service_account.app.email}"
}
