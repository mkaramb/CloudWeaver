
resource "cdap_namespace" "namespace" {
  name = var.name
}

resource "cdap_namespace_preferences" "preferences" {
  namespace   = cdap_namespace.namespace.name
  preferences = var.preferences
}
