# Dev Vault #

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

# Prod Vault #

1. Start prod vault
sudo systemctl start vault

2. See the logs under vault
sudo journalctl -u vault

3. Initialize the vault
export VAULT_ADDR='http://127.0.0.1:8200'
vault operator init

4. Unseal the vault
vault operator unseal

5. Log into vault
vault login

6. Enable new secrets path
vault secrets enable -path=aws kv <-In here kv means auth method

7. Remove the newly added path 
vault secrets disable aws/

8. Add secrets into the newly added path
vault kv put aws/administrator/user user=administrator
vault kv put aws/administrator/password password=abc123

9. Preview the added secrets 
vault kv get aws/administrator/user
vault kv get aws/administrator/password

10. Configure logs for the vault service
touch /var/log/vault.log
chown vault:vault /var/log/vault.log
vault audit enable file file_path=/var/log/vault.log

11. List auth methods
vault auth list

12. Update the description of a secret
vault secrets tune -description="aws credentials" aws/

13. Enable auth aws for -path=aws-data
vault auth enable -path=aws-data aws

14. Update the description of a auto method
vault auth tune -description="aws credentials" aws-data/

15. Enable bash completion for vautl
vault -autocomplete-install && source $HOME/.bashrc