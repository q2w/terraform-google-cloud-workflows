/**
 * Copyright 2022 Google LLC
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

variable "project_id" {
  description = "The project ID to deploy to"
  type        = string
}

variable "location" {
  description = "The name of the region where workflow will be created"
  type        = string
}

variable "name" {
  description = "The name of the event arc"
  type        = string
}

variable "service_account_email" {
  description = "Service account email. Unused if service account is auto-created."
  type        = string
  default     = null
}

variable "matching_criteria" {
  type    = list(object({ attribute : string, value : string }))
  default = []
}

variable "cloud_run_service_destination" {
  type    = list(object({ service : string, location : string }))
  default = []
}