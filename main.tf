#####
# WAFv2 web acl
#####
resource "aws_wafv2_web_acl" "main" {
  count = var.enabled ? 1 : 0

  name  = var.name_prefix
  scope = var.scope

  description = var.description

  default_action {
    dynamic "allow" {
      for_each = var.allow_default_action ? [1] : []
      content {}
    }

    dynamic "block" {
      for_each = var.allow_default_action ? [] : [1]
      content {}
    }
  }

  dynamic "rule" {
    for_each = var.rules
    content {
      name     = lookup(rule.value, "name")
      priority = lookup(rule.value, "priority")

      # Action block is required for geo_match, ip_set, and ip_rate_based rules
      dynamic "action" {
        for_each = length(lookup(rule.value, "action", {})) == 0 ? [] : [1]
        content {
          dynamic "allow" {
            for_each = lookup(rule.value, "action", {}) == "allow" ? [1] : []
            content {}
          }

          dynamic "count" {
            for_each = lookup(rule.value, "action", {}) == "count" ? [1] : []
            content {}
          }

          dynamic "block" {
            for_each = lookup(rule.value, "action", {}) == "block" ? [1] : []
            content {}
          }
        }
      }

      # Required for managed_rule_group_statements. Set to none, otherwise count to override the default action
      dynamic "override_action" {
        for_each = length(lookup(rule.value, "override_action", {})) == 0 ? [] : [1]
        content {
          dynamic "none" {
            for_each = lookup(rule.value, "override_action", {}) == "none" ? [1] : []
            content {}
          }

          dynamic "count" {
            for_each = lookup(rule.value, "override_action", {}) == "count" ? [1] : []
            content {}
          }
        }
      }

      statement {

        dynamic "managed_rule_group_statement" {
          for_each = length(lookup(rule.value, "managed_rule_group_statement", {})) == 0 ? [] : [lookup(rule.value, "managed_rule_group_statement", {})]
          content {
            name        = lookup(managed_rule_group_statement.value, "name")
            vendor_name = lookup(managed_rule_group_statement.value, "vendor_name", "AWS")

            dynamic "excluded_rule" {
              for_each = length(lookup(managed_rule_group_statement.value, "excluded_rule", {})) == 0 ? [] : toset(lookup(managed_rule_group_statement.value, "excluded_rule"))
              content {
                name = excluded_rule.value
              }
            }

            dynamic "scope_down_statement" {
              for_each = length(lookup(managed_rule_group_statement.value, "scope_down_statement", {})) == 0 ? [] : [lookup(managed_rule_group_statement.value, "scope_down_statement", {})]
              content {
                # scope down byte_match_statement
                dynamic "byte_match_statement" {
                  for_each = length(lookup(scope_down_statement.value, "byte_match_statement", {})) == 0 ? [] : [lookup(scope_down_statement.value, "byte_match_statement", {})]
                  content {
                    dynamic "field_to_match" {
                      for_each = length(lookup(byte_match_statement.value, "field_to_match", {})) == 0 ? [] : [lookup(byte_match_statement.value, "field_to_match", {})]
                      content {
                        dynamic "uri_path" {
                          for_each = length(lookup(field_to_match.value, "uri_path", {})) == 0 ? [] : [lookup(field_to_match.value, "uri_path")]
                          content {}
                        }
                        dynamic "all_query_arguments" {
                          for_each = length(lookup(field_to_match.value, "all_query_arguments", {})) == 0 ? [] : [lookup(field_to_match.value, "all_query_arguments")]
                          content {}
                        }
                        dynamic "body" {
                          for_each = length(lookup(field_to_match.value, "body", {})) == 0 ? [] : [lookup(field_to_match.value, "body")]
                          content {}
                        }
                        dynamic "method" {
                          for_each = length(lookup(field_to_match.value, "method", {})) == 0 ? [] : [lookup(field_to_match.value, "method")]
                          content {}
                        }
                        dynamic "query_string" {
                          for_each = length(lookup(field_to_match.value, "query_string", {})) == 0 ? [] : [lookup(field_to_match.value, "query_string")]
                          content {}
                        }
                        dynamic "single_header" {
                          for_each = length(lookup(field_to_match.value, "single_header", {})) == 0 ? [] : [lookup(field_to_match.value, "single_header")]
                          content {
                            name = lower(lookup(single_header.value, "name"))
                          }
                        }
                      }
                    }
                    positional_constraint = lookup(byte_match_statement.value, "positional_constraint")
                    search_string         = lookup(byte_match_statement.value, "search_string")
                    text_transformation {
                      priority = lookup(byte_match_statement.value, "priority")
                      type     = lookup(byte_match_statement.value, "type")
                    }
                  }
                }

                # scope down geo_match_statement
                dynamic "geo_match_statement" {
                  for_each = length(lookup(scope_down_statement.value, "geo_match_statement", {})) == 0 ? [] : [lookup(scope_down_statement.value, "geo_match_statement", {})]
                  content {
                    country_codes = lookup(geo_match_statement.value, "country_codes")
                  }
                }

                # scope down NOT statements
                dynamic "not_statement" {
                  for_each = length(lookup(scope_down_statement.value, "not_statement", {})) == 0 ? [] : [lookup(scope_down_statement.value, "not_statement", {})]
                  content {
                    statement {
                      # scope down NOT byte_match_statement
                      dynamic "byte_match_statement" {
                        for_each = length(lookup(not_statement.value, "byte_match_statement", {})) == 0 ? [] : [lookup(not_statement.value, "byte_match_statement", {})]
                        content {
                          dynamic "field_to_match" {
                            for_each = length(lookup(byte_match_statement.value, "field_to_match", {})) == 0 ? [] : [lookup(byte_match_statement.value, "field_to_match", {})]
                            content {
                              dynamic "uri_path" {
                                for_each = length(lookup(field_to_match.value, "uri_path", {})) == 0 ? [] : [lookup(field_to_match.value, "uri_path")]
                                content {}
                              }
                              dynamic "all_query_arguments" {
                                for_each = length(lookup(field_to_match.value, "all_query_arguments", {})) == 0 ? [] : [lookup(field_to_match.value, "all_query_arguments")]
                                content {}
                              }
                              dynamic "body" {
                                for_each = length(lookup(field_to_match.value, "body", {})) == 0 ? [] : [lookup(field_to_match.value, "body")]
                                content {}
                              }
                              dynamic "method" {
                                for_each = length(lookup(field_to_match.value, "method", {})) == 0 ? [] : [lookup(field_to_match.value, "method")]
                                content {}
                              }
                              dynamic "query_string" {
                                for_each = length(lookup(field_to_match.value, "query_string", {})) == 0 ? [] : [lookup(field_to_match.value, "query_string")]
                                content {}
                              }
                              dynamic "single_header" {
                                for_each = length(lookup(field_to_match.value, "single_header", {})) == 0 ? [] : [lookup(field_to_match.value, "single_header")]
                                content {
                                  name = lower(lookup(single_header.value, "name"))
                                }
                              }
                            }
                          }
                          positional_constraint = lookup(byte_match_statement.value, "positional_constraint")
                          search_string         = lookup(byte_match_statement.value, "search_string")
                          text_transformation {
                            priority = lookup(byte_match_statement.value, "priority")
                            type     = lookup(byte_match_statement.value, "type")
                          }
                        }
                      }

                      # scope down NOT geo_match_statement
                      dynamic "geo_match_statement" {
                        for_each = length(lookup(not_statement.value, "geo_match_statement", {})) == 0 ? [] : [lookup(not_statement.value, "geo_match_statement", {})]
                        content {
                          country_codes = lookup(geo_match_statement.value, "country_codes")
                        }
                      }
                    }
                  }
                }

                ### scope down AND statements (Requires at least two statements)
                dynamic "and_statement" {
                  for_each = length(lookup(scope_down_statement.value, "and_statement", {})) == 0 ? [] : [lookup(scope_down_statement.value, "and_statement", {})]
                  content {

                    dynamic "statement" {
                      for_each = lookup(and_statement.value, "statements", {})
                      content {
                        # Scope down AND byte_match_statement
                        dynamic "byte_match_statement" {
                          for_each = length(lookup(statement.value, "byte_match_statement", {})) == 0 ? [] : [lookup(statement.value, "byte_match_statement", {})]
                          content {
                            dynamic "field_to_match" {
                              for_each = length(lookup(byte_match_statement.value, "field_to_match", {})) == 0 ? [] : [lookup(byte_match_statement.value, "field_to_match", {})]
                              content {
                                dynamic "uri_path" {
                                  for_each = length(lookup(field_to_match.value, "uri_path", {})) == 0 ? [] : [lookup(field_to_match.value, "uri_path")]
                                  content {}
                                }
                                dynamic "all_query_arguments" {
                                  for_each = length(lookup(field_to_match.value, "all_query_arguments", {})) == 0 ? [] : [lookup(field_to_match.value, "all_query_arguments")]
                                  content {}
                                }
                                dynamic "body" {
                                  for_each = length(lookup(field_to_match.value, "body", {})) == 0 ? [] : [lookup(field_to_match.value, "body")]
                                  content {}
                                }
                                dynamic "method" {
                                  for_each = length(lookup(field_to_match.value, "method", {})) == 0 ? [] : [lookup(field_to_match.value, "method")]
                                  content {}
                                }
                                dynamic "query_string" {
                                  for_each = length(lookup(field_to_match.value, "query_string", {})) == 0 ? [] : [lookup(field_to_match.value, "query_string")]
                                  content {}
                                }
                                dynamic "single_header" {
                                  for_each = length(lookup(field_to_match.value, "single_header", {})) == 0 ? [] : [lookup(field_to_match.value, "single_header")]
                                  content {
                                    name = lower(lookup(single_header.value, "name"))
                                  }
                                }
                              }
                            }
                            positional_constraint = lookup(byte_match_statement.value, "positional_constraint")
                            search_string         = lookup(byte_match_statement.value, "search_string")
                            text_transformation {
                              priority = lookup(byte_match_statement.value, "priority")
                              type     = lookup(byte_match_statement.value, "type")
                            }
                          }
                        }

                        # Scope down AND geo_match_statement
                        dynamic "geo_match_statement" {
                          for_each = length(lookup(statement.value, "geo_match_statement", {})) == 0 ? [] : [lookup(statement.value, "geo_match_statement", {})]
                          content {
                            country_codes = lookup(geo_match_statement.value, "country_codes")
                          }
                        }

                        # Scope down AND ip_set_statement
                        dynamic "ip_set_reference_statement" {
                          for_each = length(lookup(statement.value, "ip_set_reference_statement", {})) == 0 ? [] : [lookup(statement.value, "ip_set_reference_statement", {})]
                          content {
                            arn = lookup(ip_set_reference_statement.value, "arn")
                          }
                        }
                      }
                    }
                  }
                }


                ### scope down OR statements (Requires at least two statements)
                dynamic "or_statement" {
                  for_each = length(lookup(scope_down_statement.value, "or_statement", {})) == 0 ? [] : [lookup(scope_down_statement.value, "or_statement", {})]
                  content {

                    dynamic "statement" {
                      for_each = lookup(or_statement.value, "statements", {})
                      content {
                        # Scope down OR byte_match_statement
                        dynamic "byte_match_statement" {
                          for_each = length(lookup(statement.value, "byte_match_statement", {})) == 0 ? [] : [lookup(statement.value, "byte_match_statement", {})]
                          content {
                            dynamic "field_to_match" {
                              for_each = length(lookup(byte_match_statement.value, "field_to_match", {})) == 0 ? [] : [lookup(byte_match_statement.value, "field_to_match", {})]
                              content {
                                dynamic "uri_path" {
                                  for_each = length(lookup(field_to_match.value, "uri_path", {})) == 0 ? [] : [lookup(field_to_match.value, "uri_path")]
                                  content {}
                                }
                                dynamic "all_query_arguments" {
                                  for_each = length(lookup(field_to_match.value, "all_query_arguments", {})) == 0 ? [] : [lookup(field_to_match.value, "all_query_arguments")]
                                  content {}
                                }
                                dynamic "body" {
                                  for_each = length(lookup(field_to_match.value, "body", {})) == 0 ? [] : [lookup(field_to_match.value, "body")]
                                  content {}
                                }
                                dynamic "method" {
                                  for_each = length(lookup(field_to_match.value, "method", {})) == 0 ? [] : [lookup(field_to_match.value, "method")]
                                  content {}
                                }
                                dynamic "query_string" {
                                  for_each = length(lookup(field_to_match.value, "query_string", {})) == 0 ? [] : [lookup(field_to_match.value, "query_string")]
                                  content {}
                                }
                                dynamic "single_header" {
                                  for_each = length(lookup(field_to_match.value, "single_header", {})) == 0 ? [] : [lookup(field_to_match.value, "single_header")]
                                  content {
                                    name = lower(lookup(single_header.value, "name"))
                                  }
                                }
                              }
                            }
                            positional_constraint = lookup(byte_match_statement.value, "positional_constraint")
                            search_string         = lookup(byte_match_statement.value, "search_string")
                            text_transformation {
                              priority = lookup(byte_match_statement.value, "priority")
                              type     = lookup(byte_match_statement.value, "type")
                            }
                          }
                        }

                        # Scope down OR geo_match_statement
                        dynamic "geo_match_statement" {
                          for_each = length(lookup(statement.value, "geo_match_statement", {})) == 0 ? [] : [lookup(statement.value, "geo_match_statement", {})]
                          content {
                            country_codes = lookup(geo_match_statement.value, "country_codes")
                          }
                        }

                        # Scope down OR ip_set_statement
                        dynamic "ip_set_reference_statement" {
                          for_each = length(lookup(statement.value, "ip_set_reference_statement", {})) == 0 ? [] : [lookup(statement.value, "ip_set_reference_statement", {})]
                          content {
                            arn = lookup(ip_set_reference_statement.value, "arn")
                          }
                        }
                      }
                    }
                  }
                }
              }
            }
          }
        }

        dynamic "byte_match_statement" {
          for_each = length(lookup(rule.value, "byte_match_statement", {})) == 0 ? [] : [lookup(rule.value, "byte_match_statement", {})]
          content {
            dynamic "field_to_match" {
              for_each = length(lookup(byte_match_statement.value, "field_to_match", {})) == 0 ? [] : [lookup(byte_match_statement.value, "field_to_match", {})]
              content {
                dynamic "uri_path" {
                  for_each = length(lookup(field_to_match.value, "uri_path", {})) == 0 ? [] : [lookup(field_to_match.value, "uri_path")]
                  content {}
                }
                dynamic "all_query_arguments" {
                  for_each = length(lookup(field_to_match.value, "all_query_arguments", {})) == 0 ? [] : [lookup(field_to_match.value, "all_query_arguments")]
                  content {}
                }
                dynamic "body" {
                  for_each = length(lookup(field_to_match.value, "body", {})) == 0 ? [] : [lookup(field_to_match.value, "body")]
                  content {}
                }
                dynamic "method" {
                  for_each = length(lookup(field_to_match.value, "method", {})) == 0 ? [] : [lookup(field_to_match.value, "method")]
                  content {}
                }
                dynamic "query_string" {
                  for_each = length(lookup(field_to_match.value, "query_string", {})) == 0 ? [] : [lookup(field_to_match.value, "query_string")]
                  content {}
                }
                dynamic "single_header" {
                  for_each = length(lookup(field_to_match.value, "single_header", {})) == 0 ? [] : [lookup(field_to_match.value, "single_header")]
                  content {
                    name = lower(lookup(single_header.value, "name"))
                  }
                }
              }
            }
            positional_constraint = lookup(byte_match_statement.value, "positional_constraint")
            search_string         = lookup(byte_match_statement.value, "search_string")
            text_transformation {
              priority = lookup(byte_match_statement.value, "priority")
              type     = lookup(byte_match_statement.value, "type")
            }
          }
        }

        dynamic "geo_match_statement" {
          for_each = length(lookup(rule.value, "geo_match_statement", {})) == 0 ? [] : [lookup(rule.value, "geo_match_statement", {})]
          content {
            country_codes = lookup(geo_match_statement.value, "country_codes")
          }
        }

        dynamic "ip_set_reference_statement" {
          for_each = length(lookup(rule.value, "ip_set_reference_statement", {})) == 0 ? [] : [lookup(rule.value, "ip_set_reference_statement", {})]
          content {
            arn = lookup(ip_set_reference_statement.value, "arn")
          }
        }

        dynamic "rate_based_statement" {
          for_each = length(lookup(rule.value, "rate_based_statement", {})) == 0 ? [] : [lookup(rule.value, "rate_based_statement", {})]
          content {
            limit              = lookup(rate_based_statement.value, "limit")
            aggregate_key_type = lookup(rate_based_statement.value, "aggregate_key_type", "IP")

            dynamic "forwarded_ip_config" {
              for_each = length(lookup(rule.value, "forwarded_ip_config", {})) == 0 ? [] : [lookup(rule.value, "forwarded_ip_config", {})]
              content {
                fallback_behavior = lookup(forwarded_ip_config.value, "fallback_behavior")
                header_name       = lookup(forwarded_ip_config.value, "header_name")
              }
            }

            dynamic "scope_down_statement" {
              for_each = length(lookup(rate_based_statement.value, "scope_down_statement", {})) == 0 ? [] : [lookup(rate_based_statement.value, "scope_down_statement", {})]
              content {
                # scope down byte_match_statement
                dynamic "byte_match_statement" {
                  for_each = length(lookup(scope_down_statement.value, "byte_match_statement", {})) == 0 ? [] : [lookup(scope_down_statement.value, "byte_match_statement", {})]
                  content {
                    dynamic "field_to_match" {
                      for_each = length(lookup(byte_match_statement.value, "field_to_match", {})) == 0 ? [] : [lookup(byte_match_statement.value, "field_to_match", {})]
                      content {
                        dynamic "uri_path" {
                          for_each = length(lookup(field_to_match.value, "uri_path", {})) == 0 ? [] : [lookup(field_to_match.value, "uri_path")]
                          content {}
                        }
                        dynamic "all_query_arguments" {
                          for_each = length(lookup(field_to_match.value, "all_query_arguments", {})) == 0 ? [] : [lookup(field_to_match.value, "all_query_arguments")]
                          content {}
                        }
                        dynamic "body" {
                          for_each = length(lookup(field_to_match.value, "body", {})) == 0 ? [] : [lookup(field_to_match.value, "body")]
                          content {}
                        }
                        dynamic "method" {
                          for_each = length(lookup(field_to_match.value, "method", {})) == 0 ? [] : [lookup(field_to_match.value, "method")]
                          content {}
                        }
                        dynamic "query_string" {
                          for_each = length(lookup(field_to_match.value, "query_string", {})) == 0 ? [] : [lookup(field_to_match.value, "query_string")]
                          content {}
                        }
                        dynamic "single_header" {
                          for_each = length(lookup(field_to_match.value, "single_header", {})) == 0 ? [] : [lookup(field_to_match.value, "single_header")]
                          content {
                            name = lower(lookup(single_header.value, "name"))
                          }
                        }
                      }
                    }
                    positional_constraint = lookup(byte_match_statement.value, "positional_constraint")
                    search_string         = lookup(byte_match_statement.value, "search_string")
                    text_transformation {
                      priority = lookup(byte_match_statement.value, "priority")
                      type     = lookup(byte_match_statement.value, "type")
                    }
                  }
                }

                # scope down geo_match_statement
                dynamic "geo_match_statement" {
                  for_each = length(lookup(scope_down_statement.value, "geo_match_statement", {})) == 0 ? [] : [lookup(scope_down_statement.value, "geo_match_statement", {})]
                  content {
                    country_codes = lookup(geo_match_statement.value, "country_codes")
                  }
                }

                # scope down NOT statements
                dynamic "not_statement" {
                  for_each = length(lookup(scope_down_statement.value, "not_statement", {})) == 0 ? [] : [lookup(scope_down_statement.value, "not_statement", {})]
                  content {
                    statement {
                      # scope down NOT byte_match_statement
                      dynamic "byte_match_statement" {
                        for_each = length(lookup(not_statement.value, "byte_match_statement", {})) == 0 ? [] : [lookup(not_statement.value, "byte_match_statement", {})]
                        content {
                          dynamic "field_to_match" {
                            for_each = length(lookup(byte_match_statement.value, "field_to_match", {})) == 0 ? [] : [lookup(byte_match_statement.value, "field_to_match", {})]
                            content {
                              dynamic "uri_path" {
                                for_each = length(lookup(field_to_match.value, "uri_path", {})) == 0 ? [] : [lookup(field_to_match.value, "uri_path")]
                                content {}
                              }
                              dynamic "all_query_arguments" {
                                for_each = length(lookup(field_to_match.value, "all_query_arguments", {})) == 0 ? [] : [lookup(field_to_match.value, "all_query_arguments")]
                                content {}
                              }
                              dynamic "body" {
                                for_each = length(lookup(field_to_match.value, "body", {})) == 0 ? [] : [lookup(field_to_match.value, "body")]
                                content {}
                              }
                              dynamic "method" {
                                for_each = length(lookup(field_to_match.value, "method", {})) == 0 ? [] : [lookup(field_to_match.value, "method")]
                                content {}
                              }
                              dynamic "query_string" {
                                for_each = length(lookup(field_to_match.value, "query_string", {})) == 0 ? [] : [lookup(field_to_match.value, "query_string")]
                                content {}
                              }
                              dynamic "single_header" {
                                for_each = length(lookup(field_to_match.value, "single_header", {})) == 0 ? [] : [lookup(field_to_match.value, "single_header")]
                                content {
                                  name = lower(lookup(single_header.value, "name"))
                                }
                              }
                            }
                          }
                          positional_constraint = lookup(byte_match_statement.value, "positional_constraint")
                          search_string         = lookup(byte_match_statement.value, "search_string")
                          text_transformation {
                            priority = lookup(byte_match_statement.value, "priority")
                            type     = lookup(byte_match_statement.value, "type")
                          }
                        }
                      }

                      # scope down NOT geo_match_statement
                      dynamic "geo_match_statement" {
                        for_each = length(lookup(not_statement.value, "geo_match_statement", {})) == 0 ? [] : [lookup(not_statement.value, "geo_match_statement", {})]
                        content {
                          country_codes = lookup(geo_match_statement.value, "country_codes")
                        }
                      }
                    }
                  }
                }

                ### scope down AND statements (Requires at least two statements)
                dynamic "and_statement" {
                  for_each = length(lookup(scope_down_statement.value, "and_statement", {})) == 0 ? [] : [lookup(scope_down_statement.value, "and_statement", {})]
                  content {

                    dynamic "statement" {
                      for_each = lookup(and_statement.value, "statements", {})
                      content {
                        # Scope down AND byte_match_statement
                        dynamic "byte_match_statement" {
                          for_each = length(lookup(statement.value, "byte_match_statement", {})) == 0 ? [] : [lookup(statement.value, "byte_match_statement", {})]
                          content {
                            dynamic "field_to_match" {
                              for_each = length(lookup(byte_match_statement.value, "field_to_match", {})) == 0 ? [] : [lookup(byte_match_statement.value, "field_to_match", {})]
                              content {
                                dynamic "uri_path" {
                                  for_each = length(lookup(field_to_match.value, "uri_path", {})) == 0 ? [] : [lookup(field_to_match.value, "uri_path")]
                                  content {}
                                }
                                dynamic "all_query_arguments" {
                                  for_each = length(lookup(field_to_match.value, "all_query_arguments", {})) == 0 ? [] : [lookup(field_to_match.value, "all_query_arguments")]
                                  content {}
                                }
                                dynamic "body" {
                                  for_each = length(lookup(field_to_match.value, "body", {})) == 0 ? [] : [lookup(field_to_match.value, "body")]
                                  content {}
                                }
                                dynamic "method" {
                                  for_each = length(lookup(field_to_match.value, "method", {})) == 0 ? [] : [lookup(field_to_match.value, "method")]
                                  content {}
                                }
                                dynamic "query_string" {
                                  for_each = length(lookup(field_to_match.value, "query_string", {})) == 0 ? [] : [lookup(field_to_match.value, "query_string")]
                                  content {}
                                }
                                dynamic "single_header" {
                                  for_each = length(lookup(field_to_match.value, "single_header", {})) == 0 ? [] : [lookup(field_to_match.value, "single_header")]
                                  content {
                                    name = lower(lookup(single_header.value, "name"))
                                  }
                                }
                              }
                            }
                            positional_constraint = lookup(byte_match_statement.value, "positional_constraint")
                            search_string         = lookup(byte_match_statement.value, "search_string")
                            text_transformation {
                              priority = lookup(byte_match_statement.value, "priority")
                              type     = lookup(byte_match_statement.value, "type")
                            }
                          }
                        }

                        # Scope down AND geo_match_statement
                        dynamic "geo_match_statement" {
                          for_each = length(lookup(statement.value, "geo_match_statement", {})) == 0 ? [] : [lookup(statement.value, "geo_match_statement", {})]
                          content {
                            country_codes = lookup(geo_match_statement.value, "country_codes")
                          }
                        }

                        # Scope down AND ip_set_statement
                        dynamic "ip_set_reference_statement" {
                          for_each = length(lookup(statement.value, "ip_set_reference_statement", {})) == 0 ? [] : [lookup(statement.value, "ip_set_reference_statement", {})]
                          content {
                            arn = lookup(ip_set_reference_statement.value, "arn")
                          }
                        }
                      }
                    }
                  }
                }


                ### scope down OR statements (Requires at least two statements)
                dynamic "or_statement" {
                  for_each = length(lookup(scope_down_statement.value, "or_statement", {})) == 0 ? [] : [lookup(scope_down_statement.value, "or_statement", {})]
                  content {

                    dynamic "statement" {
                      for_each = lookup(or_statement.value, "statements", {})
                      content {
                        # Scope down OR byte_match_statement
                        dynamic "byte_match_statement" {
                          for_each = length(lookup(statement.value, "byte_match_statement", {})) == 0 ? [] : [lookup(statement.value, "byte_match_statement", {})]
                          content {
                            dynamic "field_to_match" {
                              for_each = length(lookup(byte_match_statement.value, "field_to_match", {})) == 0 ? [] : [lookup(byte_match_statement.value, "field_to_match", {})]
                              content {
                                dynamic "uri_path" {
                                  for_each = length(lookup(field_to_match.value, "uri_path", {})) == 0 ? [] : [lookup(field_to_match.value, "uri_path")]
                                  content {}
                                }
                                dynamic "all_query_arguments" {
                                  for_each = length(lookup(field_to_match.value, "all_query_arguments", {})) == 0 ? [] : [lookup(field_to_match.value, "all_query_arguments")]
                                  content {}
                                }
                                dynamic "body" {
                                  for_each = length(lookup(field_to_match.value, "body", {})) == 0 ? [] : [lookup(field_to_match.value, "body")]
                                  content {}
                                }
                                dynamic "method" {
                                  for_each = length(lookup(field_to_match.value, "method", {})) == 0 ? [] : [lookup(field_to_match.value, "method")]
                                  content {}
                                }
                                dynamic "query_string" {
                                  for_each = length(lookup(field_to_match.value, "query_string", {})) == 0 ? [] : [lookup(field_to_match.value, "query_string")]
                                  content {}
                                }
                                dynamic "single_header" {
                                  for_each = length(lookup(field_to_match.value, "single_header", {})) == 0 ? [] : [lookup(field_to_match.value, "single_header")]
                                  content {
                                    name = lower(lookup(single_header.value, "name"))
                                  }
                                }
                              }
                            }
                            positional_constraint = lookup(byte_match_statement.value, "positional_constraint")
                            search_string         = lookup(byte_match_statement.value, "search_string")
                            text_transformation {
                              priority = lookup(byte_match_statement.value, "priority")
                              type     = lookup(byte_match_statement.value, "type")
                            }
                          }
                        }

                        # Scope down OR geo_match_statement
                        dynamic "geo_match_statement" {
                          for_each = length(lookup(statement.value, "geo_match_statement", {})) == 0 ? [] : [lookup(statement.value, "geo_match_statement", {})]
                          content {
                            country_codes = lookup(geo_match_statement.value, "country_codes")
                          }
                        }

                        # Scope down OR ip_set_statement
                        dynamic "ip_set_reference_statement" {
                          for_each = length(lookup(statement.value, "ip_set_reference_statement", {})) == 0 ? [] : [lookup(statement.value, "ip_set_reference_statement", {})]
                          content {
                            arn = lookup(ip_set_reference_statement.value, "arn")
                          }
                        }
                      }
                    }
                  }
                }
              }
            }
          }
        }

        ### NOT STATEMENTS
        dynamic "not_statement" {
          for_each = length(lookup(rule.value, "not_statement", {})) == 0 ? [] : [lookup(rule.value, "not_statement", {})]
          content {
            statement {

              # NOT byte_match_statement
              dynamic "byte_match_statement" {
                for_each = length(lookup(not_statement.value, "byte_match_statement", {})) == 0 ? [] : [lookup(not_statement.value, "byte_match_statement", {})]
                content {
                  dynamic "field_to_match" {
                    for_each = length(lookup(byte_match_statement.value, "field_to_match", {})) == 0 ? [] : [lookup(byte_match_statement.value, "field_to_match", {})]
                    content {
                      dynamic "uri_path" {
                        for_each = length(lookup(field_to_match.value, "uri_path", {})) == 0 ? [] : [lookup(field_to_match.value, "uri_path")]
                        content {}
                      }
                      dynamic "all_query_arguments" {
                        for_each = length(lookup(field_to_match.value, "all_query_arguments", {})) == 0 ? [] : [lookup(field_to_match.value, "all_query_arguments")]
                        content {}
                      }
                      dynamic "body" {
                        for_each = length(lookup(field_to_match.value, "body", {})) == 0 ? [] : [lookup(field_to_match.value, "body")]
                        content {}
                      }
                      dynamic "method" {
                        for_each = length(lookup(field_to_match.value, "method", {})) == 0 ? [] : [lookup(field_to_match.value, "method")]
                        content {}
                      }
                      dynamic "query_string" {
                        for_each = length(lookup(field_to_match.value, "query_string", {})) == 0 ? [] : [lookup(field_to_match.value, "query_string")]
                        content {}
                      }
                      dynamic "single_header" {
                        for_each = length(lookup(field_to_match.value, "single_header", {})) == 0 ? [] : [lookup(field_to_match.value, "single_header")]
                        content {
                          name = lower(lookup(single_header.value, "name"))
                        }
                      }
                    }
                  }
                  positional_constraint = lookup(byte_match_statement.value, "positional_constraint")
                  search_string         = lookup(byte_match_statement.value, "search_string")
                  text_transformation {
                    priority = lookup(byte_match_statement.value, "priority")
                    type     = lookup(byte_match_statement.value, "type")
                  }
                }
              }

              # NOT geo_match_statement
              dynamic "geo_match_statement" {
                for_each = length(lookup(not_statement.value, "geo_match_statement", {})) == 0 ? [] : [lookup(not_statement.value, "geo_match_statement", {})]
                content {
                  country_codes = lookup(geo_match_statement.value, "country_codes")
                }
              }

              # NOT ip_set_statement
              dynamic "ip_set_reference_statement" {
                for_each = length(lookup(not_statement.value, "ip_set_reference_statement", {})) == 0 ? [] : [lookup(not_statement.value, "ip_set_reference_statement", {})]
                content {
                  arn = lookup(ip_set_reference_statement.value, "arn")
                }
              }
            }
          }
        }

        ### AND STATEMENTS (Requires at least two statements)
        dynamic "and_statement" {
          for_each = length(lookup(rule.value, "and_statement", {})) == 0 ? [] : [lookup(rule.value, "and_statement", {})]
          content {

            dynamic "statement" {
              for_each = lookup(and_statement.value, "statements", {})
              content {

                # AND byte_match_statement
                dynamic "byte_match_statement" {
                  for_each = length(lookup(statement.value, "byte_match_statement", {})) == 0 ? [] : [lookup(statement.value, "byte_match_statement", {})]
                  content {
                    dynamic "field_to_match" {
                      for_each = length(lookup(byte_match_statement.value, "field_to_match", {})) == 0 ? [] : [lookup(byte_match_statement.value, "field_to_match", {})]
                      content {
                        dynamic "uri_path" {
                          for_each = length(lookup(field_to_match.value, "uri_path", {})) == 0 ? [] : [lookup(field_to_match.value, "uri_path")]
                          content {}
                        }
                        dynamic "all_query_arguments" {
                          for_each = length(lookup(field_to_match.value, "all_query_arguments", {})) == 0 ? [] : [lookup(field_to_match.value, "all_query_arguments")]
                          content {}
                        }
                        dynamic "body" {
                          for_each = length(lookup(field_to_match.value, "body", {})) == 0 ? [] : [lookup(field_to_match.value, "body")]
                          content {}
                        }
                        dynamic "method" {
                          for_each = length(lookup(field_to_match.value, "method", {})) == 0 ? [] : [lookup(field_to_match.value, "method")]
                          content {}
                        }
                        dynamic "query_string" {
                          for_each = length(lookup(field_to_match.value, "query_string", {})) == 0 ? [] : [lookup(field_to_match.value, "query_string")]
                          content {}
                        }
                        dynamic "single_header" {
                          for_each = length(lookup(field_to_match.value, "single_header", {})) == 0 ? [] : [lookup(field_to_match.value, "single_header")]
                          content {
                            name = lower(lookup(single_header.value, "name"))
                          }
                        }
                      }
                    }
                    positional_constraint = lookup(byte_match_statement.value, "positional_constraint")
                    search_string         = lookup(byte_match_statement.value, "search_string")
                    text_transformation {
                      priority = lookup(byte_match_statement.value, "priority")
                      type     = lookup(byte_match_statement.value, "type")
                    }
                  }
                }

                # AND geo_match_statement
                dynamic "geo_match_statement" {
                  for_each = length(lookup(statement.value, "geo_match_statement", {})) == 0 ? [] : [lookup(statement.value, "geo_match_statement", {})]
                  content {
                    country_codes = lookup(geo_match_statement.value, "country_codes")
                  }
                }

                # AND ip_set_statement
                dynamic "ip_set_reference_statement" {
                  for_each = length(lookup(statement.value, "ip_set_reference_statement", {})) == 0 ? [] : [lookup(statement.value, "ip_set_reference_statement", {})]
                  content {
                    arn = lookup(ip_set_reference_statement.value, "arn")
                  }
                }
              }
            }
          }
        }

        ### OR STATEMENTS (Requires at least two statements)
        dynamic "or_statement" {
          for_each = length(lookup(rule.value, "or_statement", {})) == 0 ? [] : [lookup(rule.value, "or_statement", {})]
          content {

            dynamic "statement" {
              for_each = lookup(or_statement.value, "statements", {})
              content {

                # OR byte_match_statement
                dynamic "byte_match_statement" {
                  for_each = length(lookup(statement.value, "byte_match_statement", {})) == 0 ? [] : [lookup(statement.value, "byte_match_statement", {})]
                  content {
                    dynamic "field_to_match" {
                      for_each = length(lookup(byte_match_statement.value, "field_to_match", {})) == 0 ? [] : [lookup(byte_match_statement.value, "field_to_match", {})]
                      content {
                        dynamic "uri_path" {
                          for_each = length(lookup(field_to_match.value, "uri_path", {})) == 0 ? [] : [lookup(field_to_match.value, "uri_path")]
                          content {}
                        }
                        dynamic "all_query_arguments" {
                          for_each = length(lookup(field_to_match.value, "all_query_arguments", {})) == 0 ? [] : [lookup(field_to_match.value, "all_query_arguments")]
                          content {}
                        }
                        dynamic "body" {
                          for_each = length(lookup(field_to_match.value, "body", {})) == 0 ? [] : [lookup(field_to_match.value, "body")]
                          content {}
                        }
                        dynamic "method" {
                          for_each = length(lookup(field_to_match.value, "method", {})) == 0 ? [] : [lookup(field_to_match.value, "method")]
                          content {}
                        }
                        dynamic "query_string" {
                          for_each = length(lookup(field_to_match.value, "query_string", {})) == 0 ? [] : [lookup(field_to_match.value, "query_string")]
                          content {}
                        }
                        dynamic "single_header" {
                          for_each = length(lookup(field_to_match.value, "single_header", {})) == 0 ? [] : [lookup(field_to_match.value, "single_header")]
                          content {
                            name = lower(lookup(single_header.value, "name"))
                          }
                        }
                      }
                    }
                    positional_constraint = lookup(byte_match_statement.value, "positional_constraint")
                    search_string         = lookup(byte_match_statement.value, "search_string")
                    text_transformation {
                      priority = lookup(byte_match_statement.value, "priority")
                      type     = lookup(byte_match_statement.value, "type")
                    }
                  }
                }

                # OR geo_match_statement
                dynamic "geo_match_statement" {
                  for_each = length(lookup(statement.value, "geo_match_statement", {})) == 0 ? [] : [lookup(statement.value, "geo_match_statement", {})]
                  content {
                    country_codes = lookup(geo_match_statement.value, "country_codes")
                  }
                }

                # OR ip_set_statement
                dynamic "ip_set_reference_statement" {
                  for_each = length(lookup(statement.value, "ip_set_reference_statement", {})) == 0 ? [] : [lookup(statement.value, "ip_set_reference_statement", {})]
                  content {
                    arn = lookup(ip_set_reference_statement.value, "arn")
                  }
                }
              }
            }
          }
        }
      }

      dynamic "visibility_config" {
        for_each = length(lookup(rule.value, "visibility_config")) == 0 ? [] : [lookup(rule.value, "visibility_config", {})]
        content {
          cloudwatch_metrics_enabled = lookup(visibility_config.value, "cloudwatch_metrics_enabled", true)
          metric_name                = lookup(visibility_config.value, "metric_name", "${var.name_prefix}-default-rule-metric-name")
          sampled_requests_enabled   = lookup(visibility_config.value, "sampled_requests_enabled", true)
        }
      }
    }
  }

  tags = var.tags

  dynamic "visibility_config" {
    for_each = length(var.visibility_config) == 0 ? [] : [var.visibility_config]
    content {
      cloudwatch_metrics_enabled = lookup(visibility_config.value, "cloudwatch_metrics_enabled", true)
      metric_name                = lookup(visibility_config.value, "metric_name", "${var.name_prefix}-default-web-acl-metric-name")
      sampled_requests_enabled   = lookup(visibility_config.value, "sampled_requests_enabled", true)
    }
  }
}

#####
# WAFv2 web acl association with ALB
#####
resource "aws_wafv2_web_acl_association" "main" {
  count = var.enabled && var.create_alb_association && length(var.alb_arn_list) == 0 ? 1 : 0

  resource_arn = var.alb_arn
  web_acl_arn  = aws_wafv2_web_acl.main[0].arn

  depends_on = [aws_wafv2_web_acl.main]
}

resource "aws_wafv2_web_acl_association" "alb_list" {
  count = var.enabled && var.create_alb_association && length(var.alb_arn_list) > 0 ? length(var.alb_arn_list) : 0

  resource_arn = var.alb_arn_list[count.index]
  web_acl_arn  = aws_wafv2_web_acl.main[0].arn

  depends_on = [aws_wafv2_web_acl.main]
}

#####
# WAFv2 web acl logging configuration with kinesis firehose
#####
resource "aws_wafv2_web_acl_logging_configuration" "main" {
  count = var.enabled && var.create_logging_configuration ? 1 : 0

  log_destination_configs = var.log_destination_configs
  resource_arn            = aws_wafv2_web_acl.main[0].arn

  dynamic "redacted_fields" {
    for_each = var.redacted_fields
    content {
      dynamic "single_header" {
        for_each = length(lookup(redacted_fields.value, "single_header", {})) == 0 ? [] : [lookup(redacted_fields.value, "single_header", {})]
        content {
          name = lookup(single_header.value, "name", null)
        }
      }

      dynamic "single_query_argument" {
        for_each = length(lookup(redacted_fields.value, "single_query_argument", {})) == 0 ? [] : [lookup(redacted_fields.value, "single_query_argument", {})]
        content {
          name = lookup(single_query_argument.value, "name", null)
        }
      }
    }
  }

  dynamic "logging_filter" {
    for_each = length(var.logging_filter) == 0 ? [] : [var.logging_filter]
    content {
      default_behavior = lookup(logging_filter.value, "default_behavior", "KEEP")

      dynamic "filter" {
        for_each = length(lookup(logging_filter.value, "filter", {})) == 0 ? [] : toset(lookup(logging_filter.value, "filter"))
        content {
          behavior    = lookup(filter.value, "behavior")
          requirement = lookup(filter.value, "requirement", "MEETS_ANY")

          dynamic "condition" {
            for_each = length(lookup(filter.value, "condition", {})) == 0 ? [] : toset(lookup(filter.value, "condition"))
            content {
              dynamic "action_condition" {
                for_each = length(lookup(condition.value, "action_condition", {})) == 0 ? [] : [lookup(condition.value, "action_condition", {})]
                content {
                  action = lookup(action_condition.value, "action")
                }
              }

              dynamic "label_name_condition" {
                for_each = length(lookup(condition.value, "label_name_condition", {})) == 0 ? [] : [lookup(condition.value, "label_name_condition", {})]
                content {
                  label_name = lookup(label_name_condition.value, "label_name")
                }
              }
            }
          }
        }
      }
    }
  }
}
