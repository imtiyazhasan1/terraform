resource "kubernetes_cluster_role" "cluster_admin_role" {
  depends_on   = [kubernetes_config_map.aws_auth]
  metadata {
    name       = "cluster-admin-role"
  }

  rule {
    api_groups = [""]
    resources  = ["persistentvolumes"]
    verbs      = ["get", "list", "watch", "create", "update", "delete", "patch"]
  }
  rule {
    api_groups = [""]
    resources  = ["nodes"]
    verbs      = ["get", "list", "watch"]
  }
  rule {
    api_groups = ["storage.k8s.io"]
    resources  = ["storageclasses"]
    verbs      = ["get", "list", "watch"]
  }
}

resource "kubernetes_cluster_role" "ns_admin" {
  depends_on  = [kubernetes_config_map.aws_auth]
  metadata {
    name      = "ns-admin"
  }
  rule {
    api_groups = ["*"]
    resources  = ["*"]
    verbs      = ["*"]
  }
}

resource "kubernetes_cluster_role" "ns_reader" {
  depends_on  = [kubernetes_config_map.aws_auth]
  metadata {
    name      = "ns-reader"
  }
  rule {
    api_groups = ["*"]
    resources  = ["*"]
    verbs      = ["get", "list", "watch"]
  }
}

resource "kubernetes_namespace" "ns" {
  depends_on  = [kubernetes_config_map.aws_auth]
  count       = length(var.namespaces)
  metadata {
    name      = "${element(var.namespaces, count.index)["namespace_name"]}"
  }
}

resource "kubernetes_role_binding" "ns_role_binding" {
  depends_on  = [kubernetes_namespace.ns,kubernetes_cluster_role.ns_reader,kubernetes_cluster_role.ns_admin]
  count       = length(var.namespaces)
  metadata {
    name      = "${element(var.namespaces, count.index)["ns_role"]}"
    namespace = "${element(var.namespaces, count.index)["namespace_name"]}"
  }
  role_ref {
    kind      = "ClusterRole"
    name      = "${element(var.namespaces, count.index)["ns_role"]}"
    api_group = "rbac.authorization.k8s.io"
  }
  subject {
    kind      = "User"
    name      = "${element(var.namespaces, count.index)["aws_role"]}"
    api_group = "rbac.authorization.k8s.io"
  }
  # dynamic "subject" {
  # for_each = "${element(var.namespaces, count.index)["aws_role"]}"
  #   content {
  #     kind      = "User"
  #     name      = subject.value
  #     api_group = "rbac.authorization.k8s.io"
  #   }
  # }
}

resource "kubernetes_cluster_role_binding" "cluster_admin_role_binding" {
  depends_on  = [aws_eks_cluster.eks-cluster,kubernetes_namespace.ns,kubernetes_cluster_role.cluster_admin_role]
  count       = length(var.namespaces)
  metadata {
    name      = "crb-${count.index + 1}"
  }
  role_ref {
    api_group = "rbac.authorization.k8s.io"
    kind      = "ClusterRole"
    name      = "cluster-admin-role"
  }
  dynamic "subject" {
  for_each = var.namespaces
    content {
      kind      = "User"
      name      = subject.value["aws_role"]
      api_group = "rbac.authorization.k8s.io"
    }
  }
}

resource "kubernetes_role_binding" "ns_role_binding_update" {
  depends_on  = [kubernetes_namespace.ns,kubernetes_cluster_role.ns_reader,kubernetes_cluster_role.ns_admin]
  count       = length(var.add_role_to_namespace)
  metadata {
    name      = "${element(var.add_role_to_namespace, count.index)["ns_role"]}"
    namespace = "${element(var.add_role_to_namespace, count.index)["namespace_name"]}"
  }
  role_ref {
    api_group = "rbac.authorization.k8s.io"
    kind      = "ClusterRole"
    name      = "${element(var.add_role_to_namespace, count.index)["ns_role"]}"
  }
  subject {
    kind      = "User"
    name      = "${element(var.add_role_to_namespace, count.index)["aws_role"]}"
    api_group = "rbac.authorization.k8s.io"
  }
}

resource "kubernetes_resource_quota" "namespace_quota" {
  depends_on = [kubernetes_namespace.ns]
  count      = length(var.namespaces_quota)
  metadata {
    name      = "${element(var.namespaces_quota, count.index)["namespace_name"]}-quota"
    namespace = "${element(var.namespaces_quota, count.index)["namespace_name"]}"
  }
  spec {
    hard = {
      cpu    = "${element(var.namespaces_quota, count.index)["cpu"]}"
      memory = "${element(var.namespaces_quota, count.index)["memory"]}"
    }
    # scopes = ["BestEffort"]
  }
}