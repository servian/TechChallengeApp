environment = {
  name                              = "ci"
}

resource_group = {
  name                              = "tech-challenge"
}

keyvault = {
  name                              = "chapp"
  #manager_id                        = "6ebf771e-ffac-4d49-b440-98c958ca6900"
}

application                         = {
  name                              = "chappweb"
  default_image                     = "eliasm50/techchallengeapp:latest"
  app_listening_port                = "80"
  health_check_path                 = "/healthcheck" # Path to the application healthcheck
  app_logs_level                    = "Information"
  zone_redundant                    = "false"        # Turn this feature on for high availability. Workload woudl be available in a secondary zone. You need to change skus to a minimun of premium and size v2 to enable this. More info here: https://azure.github.io/AppService/2021/08/25/App-service-support-for-availability-zones.html
  service_plan_skus_tier            = "Standard"     # PremiumV2
  service_plan_skus_size            = "S1"           # Make P1v2 to support zone redundancy.
}                                      

database_server                     = {
  storage_mb                        = 32768
  sku_name                          = "GP_Standard_D2s_v3" # Ramp up in a Production environment. Burstable tiers do not support high availability
  admin_username                    = "psqladmin"
}

database = {
  name                              = "app"
}                                      


tags = {
  environment                       = "ci"
}