# GitClear Errbit Fork

Some useful details about this fork.

## Preparing the errbit host
```
cd ansible
echo <ansible-vault-password> > .vault_pass.txt

# Edit hosts file to match your infrastructure
vim ./hosts

# Edit secrets as needed
ansible-vault edit ansible/vars/vaults/errbit_env_content.yml
ansible-vault edit ansible/vars/vaults/mongodb.yml

# basic auth password for nginx, search for 'htpasswd'
$EDITOR ansible/roles/webserver/tasks/nginx.yml

# Run the playbook
ansible-playbook provision.yml --inventory ./hosts --become
```

## Deploying errbit

First, install ruby version `2.7.6`, e.g. using [`rvm`](https://rvm.io/) or the
provided [nix devshell](../nix/README.md). Then run the following to deploy the
current remote `main` branch on GitHub to the host defined in
`config/deploy/production.rb`
```
bundle install

cap production deploy
```

This will re-deploy errbit from the remote `main` branch in this repository to
`/home/errbit/current` on errbit.gitclear.com.
