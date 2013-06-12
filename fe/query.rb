#!/usr/bin/env ruby -Ku
#coding:utf-8

require 'thread'
require 'drb/drb'

q = DRbObject.new_with_uri("druby://localhost:12345")
loop{|i|
	res_id = q.pop
	puts res_id
	`ruby judge.rb #{res_id} > /dev/null &`
}

