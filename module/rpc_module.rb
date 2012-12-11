#!/usr/bin/env ruby

module RPCModule
	def RPCModule.include_module_str mod
		"\textend " + mod.to_s + "\n"
	end
end
