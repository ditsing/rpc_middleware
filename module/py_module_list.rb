#!/usr/bin/env ruby

require 'rubygems'
require 'rubypython'
require_relative 'rpc_module'

RubyPython.start :python_exe => 'python2.7'
sys = RubyPython.import 'sys'
sys.path.append File.dirname(__FILE__)

py_module_names = Dir[File.dirname(__FILE__) + '/*.py'].collect { |file| File.basename file.chomp '.py'}

sys.path.append 'lib'
list_py_funcs = RubyPython.import 'list_py_funcs'
py_funcs_map = {}

py_module_names.each do |py_mod|
	py_methods = list_py_funcs.list_funcs py_mod
	py_methods.rubify.each do |py_method|
		if py_funcs_map[py_method]
			raise 'Multiple Python method with the same name in ' + \
				py_mod.to_s + ' and ' + py_funcs_map[py_method].to_s
		end
		py_funcs_map[py_method] = py_mod
	end
end

py_modules = {}
module PyModuleList
	extend RPCModule
end

py_funcs_map.each do |func_name, mod_name|
	if not py_modules[mod_name]
		py_modules[mod_name] = RubyPython.import mod_name
	end

	mod = py_modules[mod_name]
	PyModuleList.send( :define_method, func_name) { |*argv| mod.__send__( func_name, *argv).rubify}
end
