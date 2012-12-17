#!/usr/bin/env ruby

require_relative '../lib/rpc'

list = [ 'a', 'x', 'z', 'u', 'v', 'w', 'b', 't']
puts RPC.list_sort list

puts RPC.reverse_our_list list

puts RPC.no_such_method list
