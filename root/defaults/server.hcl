# reference: https://www.vaultproject.io/docs/configuration

api_addr = "http://0.0.0.0:8200"
cluster_addr = "https://0.0.0.0:8201"

disable_mlock = false

listener "tcp" {
    address = "0.0.0.0:8200"
    cluster_address    = "0.0.0.0:8201"
    tls_disable = "true"
    # tls_cert_file = "VAULT_HOME/certs/fullchain.pem"
    # tls_key_file  = "VAULT_HOME/certs/privkey.pem"
}

log_format = "standard"
log_level = "info"

plugin_directory = "VAULT_HOME/plugins"

# storage "raft" {
#     path    = "VAULT_DATA_DIR"
#     node_id = "node1"
# }

storage "file" {
    path = "VAULT_DATA_DIR"
}

telemetry {
#     statsite_address = "0.0.0.0:8125"
    disable_hostname = true
}

ui = true
