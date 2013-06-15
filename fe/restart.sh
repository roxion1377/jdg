#!/usr/bin/bash

ruby start.rb restart server.rb
ruby start.rb restart query.rb
#rails s -e production
kill -TERM `cat tmp/pids/unicorn.pid`
unicorn_rails -E production -D

