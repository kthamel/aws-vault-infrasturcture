# aws-vault-infrasturcture

1. Check the running Vault version
vault --version

2. Start Vault on dev mode
vault server -dev

3. Get the status of Vault [Dev mode]
export VAULT_ADDR='http://127.0.0.1:8200'
vault status

4. List the Secrets
vault secrets list

5. Add a secret from CLI
vault kv put secret/kthamel/aws user=kthamel-a

6. Retrieve the value of a secret from CLI
vault kv get secret/kthamel/aws

7. 