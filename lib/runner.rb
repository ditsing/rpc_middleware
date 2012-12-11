#!/usr/bin/env ruby

require_relative '../rpc_configure'
require_relative '../rpc_module_list'

class RPCRunner
	include Singleton
	include RPCModuleList
end

