#!/usr/bin/bash

ruby start.rb start server.rb
ruby start.rb start query.rb
#rails s -e production
unicorn_rails -E production -D
