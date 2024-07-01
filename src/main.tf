resource "azurerm_resource_group" "rg_aks" {
  name     = "rg-cac-912772-s1-aks-automatic-01"
  location = "Canada Central"
}
resource "azurerm_resource_group" "rg_managed" {
  name       = "MC_rg-cac-912772-s1-aks-automatic-01_aks-cac-912772-s1-automatic_canadacentral"
  location   = "Canada Central"
  managed_by = "/subscriptions/a73ced30-c712-4405-8828-67a833b1e39a/resourcegroups/rg-cac-912772-s1-aks-automatic-01/providers/Microsoft.ContainerService/managedClusters/aks-cac-912772-s1-automatic"

  tags = {
    "aks-managed-cluster-name" = "aks-cac-912772-s1-automatic"
    "aks-managed-cluster-rg"   = "rg-cac-912772-s1-aks-automatic-01"
  }
}
resource "azurerm_resource_group" "rg_ma" {
  name       = "MA_prom-cac-912772-s1-aks-automatic_canadacentral_managed"
  location   = "Canada Central"
  managed_by = "/subscriptions/a73ced30-c712-4405-8828-67a833b1e39a/resourcegroups/rg-cac-912772-s1-aks-automatic-01/providers/microsoft.monitor/accounts/prom-cac-912772-s1-aks-automatic"
}

###  Resources in AKS RG  ###
resource "azurerm_monitor_action_group" "action_group" {
  name                = "RecommendedAlertRules-AG-1"
  resource_group_name = azurerm_resource_group.rg_aks.name
  short_name          = "recalert1"
  email_receiver {
    email_address           = "eb@mngenvmcap912772.onmicrosoft.com"
    name                    = "Email_-EmailAction-"
    use_common_alert_schema = true
  }
}

resource "azurerm_kubernetes_cluster" "aks_auto" {
  name                                = "aks-cac-912772-s1-automatic"
  location                            = azurerm_resource_group.rg_aks.location
  resource_group_name                 = azurerm_resource_group.rg_aks.name
  dns_prefix                          = "dns-2166136261"
  automatic_channel_upgrade           = "stable"
  azure_policy_enabled                = true
  cost_analysis_enabled               = false
  custom_ca_trust_certificates_base64 = []
  http_application_routing_enabled    = false
  image_cleaner_enabled               = true
  image_cleaner_interval_hours        = 168
  local_account_disabled              = true
  kubernetes_version                  = "1.28"
  oidc_issuer_enabled                 = true
  open_service_mesh_enabled           = false
  sku_tier                            = "Standard"
  workload_identity_enabled           = true
  api_server_access_profile {
    authorized_ip_ranges     = []
    vnet_integration_enabled = true
  }

  azure_active_directory_role_based_access_control {
    admin_group_object_ids = []
    azure_rbac_enabled     = true
    managed                = true
    tenant_id              = "bed3f66f-00c5-402e-8f75-44abca53e730"
  }

  default_node_pool {
    custom_ca_trust_enabled      = false
    enable_auto_scaling          = false
    enable_host_encryption       = false
    enable_node_public_ip        = false
    fips_enabled                 = false
    kubelet_disk_type            = "OS"
    max_count                    = null
    max_pods                     = 250
    min_count                    = null
    name                         = "systempool"
    node_count                   = 1
    node_labels                  = {}
    only_critical_addons_enabled = true
    orchestrator_version         = "1.28"
    os_disk_size_gb              = 128
    os_disk_type                 = "Ephemeral"
    os_sku                       = "AzureLinux"
    tags                         = {}
    vm_size                      = "Standard_DS4_v2"
    zones = [
      "1",
      "2",
      "3",
    ]
    upgrade_settings {
      drain_timeout_in_minutes      = 0
      max_surge                     = "10%"
      node_soak_duration_in_minutes = 0
    }
  }

  identity {
    identity_ids = []
    type         = "SystemAssigned"
  }

  key_vault_secrets_provider {
    secret_rotation_enabled  = true
    secret_rotation_interval = "2m"
  }

  kubelet_identity {
    client_id                 = var.kubelet_id_client_id
    object_id                 = var.kubelet_id_object_id
    user_assigned_identity_id = var.kubelet_id_user_assigned_identity_id
  }

  maintenance_window_auto_upgrade {
    day_of_month = 0
    day_of_week  = "Sunday"
    duration     = 4
    frequency    = "Weekly"
    interval     = 1
    start_date   = "2024-06-18T00:00:00Z"
    start_time   = "00:00"
    utc_offset   = "+00:00"
  }

  microsoft_defender {
    log_analytics_workspace_id = var.law_id
  }

  network_profile {
    dns_service_ip = "10.0.0.10"
    ip_versions = [
      "IPv4",
    ]
    load_balancer_sku   = "standard"
    network_plugin      = "azure"
    network_plugin_mode = "overlay"
    network_policy      = "cilium"
    outbound_type       = "managedNATGateway"
    pod_cidr            = "10.244.0.0/16"
    pod_cidrs = [
      "10.244.0.0/16",
    ]
    service_cidr = "10.0.0.0/16"
    service_cidrs = [
      "10.0.0.0/16",
    ]

    # load_balancer_profile {
    #   idle_timeout_in_minutes  = null
    #   outbound_ports_allocated = 0
    # }

    nat_gateway_profile {
      idle_timeout_in_minutes   = 4
      managed_outbound_ip_count = 1
    }
  }

  monitor_metrics {
  }

  oms_agent {
    msi_auth_for_monitoring_enabled = true
    log_analytics_workspace_id      = var.law_id
  }

  service_mesh_profile {
    external_ingress_gateway_enabled = true
    internal_ingress_gateway_enabled = true
    mode                             = "Istio"
  }

  web_app_routing {
    dns_zone_id = null
  }
  workload_autoscaler_profile {
    keda_enabled                    = true
    vertical_pod_autoscaler_enabled = true
  }
}
