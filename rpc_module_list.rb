#!/usr/bin/env ruby

require_relative 'rpc_configure'
Dir[File.dirname(__FILE__) + '/' + RPCConfigure::ModelDir + '/*.rb'].each {|file| require file }

module RPCModuleList
##@RPCModuleList
	extend Ttest
	extend Ttest3
	extend Ttest7
##@RPCModuleList
end
