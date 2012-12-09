#!/usr/bin/ruby

class RPCCall
	attr_accessor :function_name, :argv, :error, :ret_val

	def run
		@error = false
		begin
			@ret_val = send( @function_name, @argv)
		rescue Exception => run_err
			@error = run_err
		end
	end
end

class RPCServer
	include	RPCConfigure

	class << self
		def listen
			server = TCPServer.open( CallPort)
			loop do
				Thread.start( server.accept) do |client|
					call_str = client.gets
					call = Marshal.load( call_str)
					call.run

					call_str = Marshal.dump( call)
					client.puts call_str
				end
			end
		end
	end
end

class RPCClient
	include	RPCConfigure

	class << self
		def send_call call
			call_str = Marshal.dump( call)
			server = TCPServer.open( Server, CallPort)
			server.puts call_str

			call_str = server.gets
			call = Marshal.load( call_str)

			return call
		end
	end
end
