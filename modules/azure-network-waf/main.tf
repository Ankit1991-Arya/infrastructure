

resource "azurerm_web_application_firewall_policy" "waf-resource" {
  name                = var.wafpolicy_name
  resource_group_name = var.resource_group
  location            = var.location

  custom_rules {
    name      = "Rule1"
    priority  = 1
    rule_type = "MatchRule"

    match_conditions {
      match_variables {
        variable_name = "RemoteAddr"
      }
      operator           = "IPMatch"
      negation_condition = false
      match_values       = ["192.168.1.0/24", "10.0.0.0/24"]
    }
    action = "Block"
  }

  custom_rules {
    name      = "Rule2"
    priority  = 2
    rule_type = "MatchRule"

    match_conditions {
      match_variables {
        variable_name = "RemoteAddr"
      }

      operator           = "IPMatch"
      negation_condition = false
      match_values       = ["192.168.1.0/24"]
    }

    match_conditions {
      match_variables {
        variable_name = "RequestHeaders"
        selector      = "UserAgent"
      }

      operator           = "Contains"
      negation_condition = false
      match_values       = ["Windows"]
    }

    action = "Block"
  }

  policy_settings {
    enabled            = true
    mode               = "Prevention"
    request_body_check = false
    #    file_upload_limit_in_mb     = 500
    #    max_request_body_size_in_kb = 128
  }

  managed_rules {
    exclusion {
      match_variable          = "RequestHeaderNames"
      selector                = "x-company-secret-header"
      selector_match_operator = "Equals"
    }
    exclusion {
      match_variable          = "RequestCookieNames"
      selector                = "too-tasty"
      selector_match_operator = "EndsWith"
    }

    managed_rule_set {
      type    = "OWASP"
      version = "3.1"
      rule_group_override {
        rule_group_name = "REQUEST-920-PROTOCOL-ENFORCEMENT"
        #        disabled_rules = [
        #          "920320"
        #        ]
        rule {
          id      = "920300"
          enabled = false
          action  = "Allow"
        }
        rule {
          id      = "920320"
          enabled = false
          action  = "Allow"
        }
      }
      rule_group_override {
        rule_group_name = "REQUEST-931-APPLICATION-ATTACK-RFI"
        rule {
          id      = "931130"
          enabled = false
          action  = "Allow"
        }
      }

      rule_group_override {
        rule_group_name = "REQUEST-941-APPLICATION-ATTACK-XSS"
        rule {
          id      = "941330"
          enabled = false
          action  = "Allow"
        }
        rule {
          id      = "941340"
          enabled = false
          action  = "Allow"
        }
      }
      rule_group_override {
        rule_group_name = "REQUEST-942-APPLICATION-ATTACK-SQLI"
        rule {
          id      = "942130"
          enabled = false
          action  = "Allow"
        }
        rule {
          id      = "942200"
          enabled = false
          action  = "Allow"
        }
        rule {
          id      = "942220"
          enabled = false
          action  = "Allow"
        }
        rule {
          id      = "942260"
          enabled = false
          action  = "Allow"
        }
        rule {
          id      = "942300"
          enabled = false
          action  = "Allow"
        }
        rule {
          id      = "942330"
          enabled = false
          action  = "Allow"
        }
        rule {
          id      = "942340"
          enabled = false
          action  = "Allow"
        }
        rule {
          id      = "942370"
          enabled = false
          action  = "Allow"
        }
        rule {
          id      = "942440"
          enabled = false
          action  = "Allow"
        }
        rule {
          id      = "942450"
          enabled = false
          action  = "Allow"
        }
      }
    }
  }

}