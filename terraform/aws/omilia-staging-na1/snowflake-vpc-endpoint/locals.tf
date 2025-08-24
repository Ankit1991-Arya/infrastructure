locals {
  vpc_id = "vpc-0725d25229cf3079f"

  snowflake_endpoint_dns_entry = module.omilia_privatelink_endpoint.vpc_endpoint_dns["snowflake-omilia"]

  private_snowflake_url                              = "eub12439.us-west-2.privatelink.snowflakecomputing.com"
  private_regionless_snowflake_url                   = "cxone-omilia_na1_staging.privatelink.snowflakecomputing.com"
  private_regionless_snowflake_url_with_hyphens      = replace(local.private_regionless_snowflake_url, "_", "-")
  private_snowflake_ocsp_url                         = "ocsp.eub12439.us-west-2.privatelink.snowflakecomputing.com"
  private_regionless_snowflake_ocsp_url              = "ocsp.${local.private_regionless_snowflake_url}"
  private_regionless_snowflake_ocsp_url_with_hyphens = replace(local.private_regionless_snowflake_ocsp_url, "_", "-")
  private_snowsight_url                              = "app.us-west-2.privatelink.snowflakecomputing.com"
  private_regionless_snowsight_url                   = "app-cxone-omilia_na1_staging.privatelink.snowflakecomputing.com"

  # remove privatelink.snowflakecomputing.com domain from private link urls
  private_snowflake_name                              = var.enable_snowflake_private_link ? join(".", slice(split(".", local.private_snowflake_url), 0, length(split(".", local.private_snowflake_url)) - 3)) : ""
  private_regionless_snowflake_name                   = var.enable_snowflake_private_link ? join(".", slice(split(".", local.private_regionless_snowflake_url), 0, length(split(".", local.private_regionless_snowflake_url)) - 3)) : ""
  private_regionless_snowflake_name_with_hyphens      = var.enable_snowflake_private_link ? join(".", slice(split(".", local.private_regionless_snowflake_url_with_hyphens), 0, length(split(".", local.private_regionless_snowflake_url_with_hyphens)) - 3)) : ""
  private_snowflake_ocsp_name                         = var.enable_snowflake_private_link ? join(".", slice(split(".", local.private_snowflake_ocsp_url), 0, length(split(".", local.private_snowflake_ocsp_url)) - 3)) : ""
  private_regionless_snowflake_ocsp_name              = var.enable_snowflake_private_link ? join(".", slice(split(".", local.private_regionless_snowflake_ocsp_url), 0, length(split(".", local.private_regionless_snowflake_ocsp_url)) - 3)) : ""
  private_regionless_snowflake_ocsp_name_with_hyphens = var.enable_snowflake_private_link ? join(".", slice(split(".", local.private_regionless_snowflake_ocsp_url_with_hyphens), 0, length(split(".", local.private_regionless_snowflake_ocsp_url_with_hyphens)) - 3)) : ""
  private_snowsight_name                              = var.enable_snowflake_private_link ? join(".", slice(split(".", local.private_snowsight_url), 0, length(split(".", local.private_snowsight_url)) - 3)) : ""
  private_regionless_snowsight_name                   = var.enable_snowflake_private_link ? join(".", slice(split(".", local.private_regionless_snowsight_url), 0, length(split(".", local.private_regionless_snowsight_url)) - 3)) : ""
}