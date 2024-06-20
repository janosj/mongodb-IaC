# Configure the MongoDB Atlas Provider to use A4G.
# This section isn't present in the Atlas Commercial version of this file.
# Note: this does NOT belong in the provider.tf file, which only identifies
# the required providers (the required version and source).
provider "mongodbatlas" {
  is_mongodbgov_cloud = true
}

# Create a Project (A4G)
resource "mongodbatlas_project" "atlas-project" {
  org_id = var.atlas_org_id
  name = var.atlas_project_name
  # This is added to create a GovCloud Project.
  # Along with the provider section above, this is the only required modification to this file.
  # Valid Atlas regions with this setting are US_GOV_EAST_1 and US_GOV_WEST_1.
  region_usage_restrictions = "GOV_REGIONS_ONLY"
}

# Create a Database User
resource "mongodbatlas_database_user" "db-user" {
  username = var.db_username
  password = random_password.db-user-password.result
  project_id = mongodbatlas_project.atlas-project.id
  auth_database_name = "admin"
  roles {
    #role_name     = "readWrite"
    #database_name = "${var.atlas_project_name}-db"
    role_name     = "readWriteAnyDatabase"
    database_name = "admin"
  }
}

# Create a Database Password
resource "random_password" "db-user-password" {
  length = 16
  special = true
  override_special = "_%@"
}

# Create Database IP Access List
resource "mongodbatlas_project_ip_access_list" "ip" {
  project_id = mongodbatlas_project.atlas-project.id
  ip_address = var.ip_address
}

# Create an Atlas Advanced Cluster
resource "mongodbatlas_advanced_cluster" "atlas-cluster" {
  project_id = mongodbatlas_project.atlas-project.id
  name = "${var.atlas_project_name}-${var.environment}-cluster"
  cluster_type = "REPLICASET"
  backup_enabled = true
  mongo_db_major_version = var.mongodb_version
  replication_specs {
    region_configs {
      electable_specs {
        instance_size = var.cluster_instance_size_name
        node_count    = 3
      }
      #analytics_specs {
      #  instance_size = var.cluster_instance_size_name
      #  node_count    = 1
      #}
      priority      = 7
      provider_name = var.cloud_provider
      region_name   = var.atlas_region
    }
  }
}

resource "mongodbatlas_cloud_backup_schedule" "test-backup" {
  project_id = mongodbatlas_project.atlas-project.id
  cluster_name = mongodbatlas_advanced_cluster.atlas-cluster.name

  reference_hour_of_day    = 3
  reference_minute_of_hour = 45
  restore_window_days      = 4


  // This will now add the desired policy items to the existing mongodbatlas_cloud_backup_schedule resource
  // See here:
  // https://registry.terraform.io/providers/mongodb/mongodbatlas/latest/docs/resources/cloud_backup_schedule
  policy_item_hourly {
    frequency_interval = 1
    retention_unit     = "days"
    retention_value    = 1
  }
  policy_item_daily {
    frequency_interval = 1
    retention_unit     = "days"
    retention_value    = 2
  }
  copy_settings {
    cloud_provider      = "AWS"
    frequencies         = ["DAILY"]
    region_name         = "US_GOV_WEST_1"
    replication_spec_id = mongodbatlas_advanced_cluster.atlas-cluster.replication_specs.*.id[0]
    should_copy_oplogs  = false
  }
}

# Outputs to Display
output "atlas_cluster_connection_string" { value = mongodbatlas_advanced_cluster.atlas-cluster.connection_strings.0.standard_srv }
output "ip_access_list"    { value = mongodbatlas_project_ip_access_list.ip.ip_address }
output "project_name"      { value = mongodbatlas_project.atlas-project.name }
output "username"          { value = mongodbatlas_database_user.db-user.username }
output "user_password"     {
  sensitive = true
  value = mongodbatlas_database_user.db-user.password
  }

