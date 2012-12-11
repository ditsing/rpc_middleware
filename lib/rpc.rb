#!/usr/bin/ruby

require 'singleton'

class RPCCall
	attr_accessor :function_name, :argv, :error, :ret_val

	def initialize( function_name, *argv)
		raise ArgumentError, 'function name must be string' \
	       		unless function_name.kind_of? String
		@function_name = function_name
		@argv = *argv
		@error = false
		@ret_val = nil
	end

	def run
		begin
			@ret_val = RPCRunner.send( @function_name, @argv)
		rescue Exception => run_err
			@error = run_err
		end
	end
end

require 'socket'
class RPCServer
	include	RPCConfigure
	include Singleton

	class << self
		def listen
			@thread = Thread.new do
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
end

class RPCClient
	include	RPCConfigure
	include Singleton

	class << self
		def send_call call
			call_str = Marshal.dump( call)
			server = TCPServer.open( RPCClient::Server, RPCClient::CallPort)
			server.puts call_str

			call_str = server.gets
			call = Marshal.load( call_str)

			return call
		end
	end
end

class RPC
	include RPCConfigure
	include Singleton

	class << self
		def method_missing( method_name, *argv, &block)
			puts method_name
			puts argv
			puts block
			raise ArgumentError, 'Cannot make RPC call with a block' if block

			define_singleton_method method_name do | *method_argv|
				puts "in that method " + method_name.to_s
				puts method_argv

				call = RPCCall.new( method_name.to_s, *method_argv)
				call = RPCClient.send_call call

				raise call.error if call.error

				return call.ret_val
			end

			return self.send( method_name, *argv)
		end
	end
end
