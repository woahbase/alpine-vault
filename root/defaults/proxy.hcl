# reference: https://developer.hashicorp.com/vault/docs/agent-and-proxy/proxy

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

api_proxy {
    use_auto_auth_token = "force"
    enforce_consistency = "always"
}

listener "unix" {
    address = "VAULT_HOME/vault.sock"
    tls_disable = true

    agent_api {
        enable_quit = true
    }
}

listener "tcp" {
    address = "127.0.0.1:8100"
    tls_disable = true
}
