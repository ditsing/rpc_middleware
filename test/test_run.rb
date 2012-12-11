#!/usr/bin/env ruby

require_relative '../lib/rpc'

list = [ 'a', 'x', 'z', 'u', 'v', 'w', 'b', 't']
puts RPC.list_sort list

list = [ 'e', 'w', 'z', 'd', 'y', 'w', 'b', 't']
puts RPC.list_sort list

puts RPC.list_sortt list
