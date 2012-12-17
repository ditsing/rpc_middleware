#!/usr/bin/env ruby

require_relative 'rpc_configure'
Dir[File.dirname(__FILE__) + '/' + RPCConfigure::ModuleDir + '/*.rb'].each {|file| require file }

class RPCModuleList
##@RPCModuleList
	extend ListSort
	extend PyModuleList
##@RPCModuleList
end
