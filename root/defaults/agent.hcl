# reference: https://developer.hashicorp.com/vault/docs/agent-and-proxy/agent

pid_file = "VAULT_HOME/pidfile"

vault {
    address = "https://127.0.0.1:8200"
    retry {
        num_retries = 5
    }
}

auto_auth {
    method "aws" {
        mount_path = "auth/aws-subaccount"
        config = {
            type = "iam"
            role = "foobar"
        }
    }

    sink "file" {
        config = {
            path = "VAULT_HOME/file-foo"
        }
    }

    sink "file" {
        wrap_ttl = "5m"
        aad_env_var = "TEST_AAD_ENV"
        dh_type = "curve25519"
        dh_path = "VAULT_HOME/file-foo-dhpath2"
        config = {
            path = "VAULT_HOME/file-bar"
        }
    }
}

cache {
    # use_auto_auth_token = true
}

template_config {
  static_secret_render_interval = "10m"
  exit_on_retry_failure = true
  max_connections_per_host = 20
}

template {
  source = "VAULT_HOME/templates/server.key.ctmpl"
  destination = "/etc/vault/server.key"
}

template {
  source = "VAULT_HOME/templates/server.crt.ctmpl"
  destination = "/etc/vault/server.crt"
}
