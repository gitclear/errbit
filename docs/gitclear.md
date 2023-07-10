# GitClear Errbit Fork

Some useful details about this fork. 

## Deploying

```
cap production deploy
``` 

Will re-deploy the app to /home/errbit/current on misc1.

## Relinking SSL certs

If you update nginx, you may need to reinstall the SSL certificate for misc1. This can be done by logging into async8
and running 

```
rails bonanza_certificates:renew_certificates RAILS_ENV=production
``` 

Or by manually running 

```
frontend = BonanzaCertificate.new("WILD")
remote_filename = "#{ frontend.frontend_name }.pem"
certificate_content = [ frontend.private_key, frontend.certificate_pem ].join
BonanzaCertificates::UploadUtils.upload_certificates(BonanzaCertificate::OTHER_SERVERS, remote_filename, certificate_content, Logger.new(STDOUT))
```
