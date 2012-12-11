#!/usr/bin/env ruby

require_relative 'rpc_module'

module ListSort
	extend RPCModule

	def list_sort list
		list.sort
	end
end
