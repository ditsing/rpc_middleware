#!/usr/bin/env ruby

require 'singleton'
require_relative '../rpc_configure'
require_relative '../rpc_module_list'

class RPCRunner < RPCModuleList
	include Singleton
end

