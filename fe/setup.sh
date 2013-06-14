#!/usr/bin/bash

mkdir task_data/contests
chmod 777 task_data/contests

bundle install

rake db:migrate
rake db:seed

