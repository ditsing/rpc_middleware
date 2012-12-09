#!/usr/bin/ruby

require 'rpc_configure'

class Scanner
	include Singleton
	include RPCConfigure

	def initialize

	class << self
		def read_list
			list = []
			File.open( FuncListName, "r") do |file|
				file.flock( File::LOCK_SH)
				file.each { |line| list.push line.chomp}
				file.flock( FILE::LOCK_UN)
			end
		end

		def merge_list!
			old_list = read_list
			new_list = scan
			list = old_list + new_list
			list.sort!
			list.uniq
			return list
		end

		def scan
			list = []
			code_lines.each do |line|
				data = /\s*def\s*(\w)(?:\s(\w)*)/.match( line)
				if data
					list.push line
				end
			end

			return list
		end

		def listen
			server = TCPServer.open( ListenPort)
			last_time = 0
			current_time = 0
			list = []
			loop do
				current_time = Time::now
				if current_time - last_time > 60
					list = read_list
					last_time = current_time
				end

				Thread.start( server.accept) do |client|
					client.puts Marshal.dump( list)
					client.close
				end
			end
		end

		def fetch
			list = []
			server = TCPServer.open( ServerHost, ListenPort)
			while line = server.gets
				list.push line.chmop
			end
			server.close

			return list
		end

		def update_list list
			File.open( FuncListName, "w") do |file|
				file.flock( File::LOCK_EX)
				list.each { |line| file.write( line)}
				file.flock( File::LOCK_UN)
			end
		end
	end
end
