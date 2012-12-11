#!/usr/bin/ruby

require 'singleton'
require_relative '../rpc_configure'
require_relative 'runner'

class RPCCall
	attr_accessor :function_name, :argv, :error, :ret_val

	def initialize( function_name, *argv)
		raise ArgumentError, 'function name must be string' \
	       		unless function_name.kind_of? Symbol
		@function_name = function_name
		@argv = *argv
		@error = false
		@ret_val = nil
	end

	def run
		begin
			@ret_val = RPCRunner.send( @function_name, *@argv)
		rescue Exception => run_err
			@error = run_err
		end
	end
end

require 'socket'

class RPCSocket
	def initialize socket
		@socket = socket
	end

	def send_rpc_call call
		call_str = Marshal.dump( call)
		@socket.puts call_str
		@socket.puts RPCConfigure::DelimterString
	end

	def recv_rpc_call
		call_str = ''
		while part = @socket.gets do
			break if part.chomp == RPCConfigure::DelimterString
			call_str += part
		end
		return Marshal.load( call_str)
	end
end

class RPCServer
	include	RPCConfigure
	include Singleton

	class << self
		def listen
			server = TCPServer.open( RPCConfigure::CallPort)
			loop do
				Thread.start( server.accept) do |client|
					client = RPCSocket.new client
					call = client.recv_rpc_call

					puts "Server: get call " + call.function_name.to_s
					puts "Server: with argv " + call.argv.to_s

					call.run
					client.send_rpc_call call
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
			server = TCPSocket.open( RPCConfigure::Server, RPCConfigure::CallPort)
			server = RPCSocket.new server

			puts "sending " + call.function_name.to_s
			puts "sending " + call.argv.to_s

			server.send_rpc_call call
			call = server.recv_rpc_call

			puts "recving " + call.ret_val.to_s
			puts "recving " + call.error.to_s

			return call
		end
	end
end

class RPC
	include RPCConfigure
	include Singleton

	class << self
		def method_missing( method_name, *argv, &block)
			puts "method_missing: get method " + method_name.to_s
			puts "method_missing: get argv " + argv.to_s

			raise ArgumentError, 'Cannot make RPC call with a block' if block

			define_singleton_method method_name do | *method_argv|
				puts "in method " + method_name.to_s
				puts "with argv " + method_argv.to_s

				call = RPCCall.new( method_name, *method_argv)
				call = RPCClient.send_call call

				raise call.error if call.error

				return call.ret_val
			end

			return self.send( method_name, *argv)
		end
	end
end
