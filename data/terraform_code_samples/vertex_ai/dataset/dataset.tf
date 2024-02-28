# [START aiplatform_dataset_parent_tag]
# [START aiplatform_create_dataset_image_sample]
resource "google_vertex_ai_dataset" "image_dataset" {
  display_name        = "image-dataset"
  metadata_schema_uri = "gs://google-cloud-aiplatform/schema/dataset/metadata/image_1.0.0.yaml"
  region              = "us-central1"
}
# [END aiplatform_create_dataset_image_sample]

# [START aiplatform_create_dataset_tabular_sample]
resource "google_vertex_ai_dataset" "tabular_dataset" {
  display_name        = "tabular-dataset"
  metadata_schema_uri = "gs://google-cloud-aiplatform/schema/dataset/metadata/tabular_1.0.0.yaml"
  region              = "us-central1"
}
# [END aiplatform_create_dataset_tabular_sample]

# [START aiplatform_create_dataset_text_sample]
resource "google_vertex_ai_dataset" "text_dataset" {
  display_name        = "text-dataset"
  metadata_schema_uri = "gs://google-cloud-aiplatform/schema/dataset/metadata/text_1.0.0.yaml"
  region              = "us-central1"
}
# [END aiplatform_create_dataset_text_sample]

# [START aiplatform_create_dataset_video_sample]
resource "google_vertex_ai_dataset" "video_dataset" {
  display_name        = "video-dataset"
  metadata_schema_uri = "gs://google-cloud-aiplatform/schema/dataset/metadata/video_1.0.0.yaml"
  region              = "us-central1"
}
# [END aiplatform_create_dataset_video_sample]
# [END aiplatform_dataset_parent_tag]
