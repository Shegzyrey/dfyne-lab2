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
  name          = "${var.project_id}-app-uploads"
  location      = var.region
  force_destory = true

  uniform_bucket_level_access = false
}

resource "google_storage_bucket_iam_memeber" "public_read" {
  bucket = google_storage_bucket.app_uploads.name
  role   = "roles/storage.objectViewer"
  member = "allUsers"
}

resource "google_service_account" "app" {
  account_id   = "app-service-account"
  display_name = "App Service Account"
}

resource "google_project_iam_memeber" "overpowered" {
  project = var.project_id
  role    = "roles/editor"
  member  = "serviceAccount:${google_service_account.app.email}"
}
