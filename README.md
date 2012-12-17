Middleware homework
================

RPC middleware. Support function calls start from a ruby program, and end at a ruby/python/php program.

How to deploy RPC server
------------------------
1. Clone this repository.
3. Edit ```rpc_configure.rb``` to meet your needs.
2. Run ```rake server```.

How to make RPC call
------------------------
1. ```require 'rpc'``` in your source code.
2. Every RPC call is a singleton method of class RPC.
4. Errors will be caught and re-throwed at the client side.
3. Example

        #!/usr/bin/env ruby
        require_relative 'rpc'

        list = [ 'a', 'x', 'z', 'u', 'v', 'w', 'b', 't']
        puts RPC.list_sort list

        puts RPC.reverse_our_list list

        puts RPC.list_sortt list

How to add custom module
------------------------
1. Ruby module
	* Add a module which extends ```RPCModule```.
	* Put the souce code file in ```RPCConfigure::ModuleDir```.
	* All module method defined within this module will be exported as an RPC call.
	* Example

			#!/usr/bin/env ruby
			require_relative 'rpc_module'
			
			module ListSort
				extend RPCModule
		  
				def list_sort list
					list.sort
				end
			end
		
2. Python module
	* Creat a new python souce code file in ```RPCConfigure::ModuleDir```.
	* All functions define with this file will be exported as an RPC call
	* Example

			#!/usr/bin/env python

			def reverse_our_list(list):
				list.reverse()
				return list
3. Both
	* Module/file names will **NOT** be included into the name of RPC call, just for logical clarity.
	* Other code of the Ruby/Python source file will be run only once when the server starts.
