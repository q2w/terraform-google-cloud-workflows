/**
 * Copyright 2025 Google LLC
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *      http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

locals {
  gcsEventProvider = contains([for item in var.matching_criteria : item.attribute if item.attribute == "bucket"], "bucket")
}

resource "google_eventarc_trigger" "trigger" {
  project         = var.project_id
  name            = var.name
  location        = var.location
  service_account = var.service_account_email

  dynamic "matching_criteria" {
    for_each = var.matching_criteria
    content {
      attribute = matching_criteria.value.attribute
      value     = matching_criteria.value.value
    }
  }

  destination {
    dynamic "cloud_run_service" {
      for_each = var.cloud_run_service_destination
      content {
        service = cloud_run_service.value.service
        region  = cloud_run_service.value.location
      }
    }
  }
}

data "google_storage_project_service_account" "gcs_account" {
  count   = local.gcsEventProvider ? 1 : 0
  project = var.project_id
}
resource "google_project_iam_member" "pubsubpublisher" {
  count   = local.gcsEventProvider ? 1 : 0
  project = var.project_id
  role    = "roles/pubsub.publisher"
  member  = "serviceAccount:${data.google_storage_project_service_account.gcs_account[0].email_address}"
}