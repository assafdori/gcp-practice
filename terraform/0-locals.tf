locals {
  prefix     = "development"
  project_id = "sunlit-descent-465915-p7"
  region     = "us-central1"
  apis = [
    "compute.googleapis.com",
    "container.googleapis.com",
    "logging.googleapis.com",
    "secretmanager.googleapis.com"
  ]
}
