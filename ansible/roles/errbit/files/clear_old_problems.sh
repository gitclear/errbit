#!/bin/bash --login

source /home/deployuser/.bashrc
rvm use ruby-2.6.9@errbit
cd /home/errbit/current && bundle exec rake errbit:db:clear_old RAILS_ENV=production
