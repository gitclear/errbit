# GitClear Errbit Fork

Some useful details about this fork. 

## Preparing the errbit host
```
cd ansible
echo <ansible-vault-password> > .vault_pass.txt

# Edit hosts file to match your infrastructure
vim ./hosts

# Run the playbook
ansible-playbook provision.yml --inventory ./hosts --become 
```

## Deploying errbit

```
cap production deploy
``` 

Will re-deploy the app to `/home/errbit/current` on errbit.gitclear.com.
