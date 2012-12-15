desc "Update rpc module list"
task :update do
	require_relative 'module/rpc_module'
	$mod_list = []
	module RPCModule
		def RPCModule.extended mod
			$mod_list.push mod
		end
	end

	require_relative 'rpc_module_list_template'

	mod_extend_list = $mod_list.collect { |mod| RPCModule.include_module_str mod}

	former_part = []
	later_part = []

	delimeter = RPCConfigure::ModuleDelimiter
	template_file_name = RPCConfigure::ModuleTemplate
	base_file_name = RPCConfigure::ModuleList
	old_file_name = base_file_name
	new_file_name = base_file_name + '.new'

	File.open( template_file_name, 'r') do |file|
		file.each { |line| break if line =~ /#{delimeter}/; former_part.push line}
		file.each { |line| break if line =~ /#{delimeter}/}
		file.each { |line| later_part.push line}
	end

	File.open( new_file_name, 'w') do |file|
		former_part.each { |line| file.write line}
		file.puts delimeter
		mod_extend_list.each { |line| file.write line}
		file.puts delimeter
		later_part.each { |line| file.write line}
	end

	if File.exist? old_file_name
		File.rename( old_file_name, old_file_name + '.bak')
	end
	File.rename( new_file_name, old_file_name)
end

task :server do
	require_relative 'lib/rpc'
	RPCServer.listen
end

task :test do
	exec 'ruby test/test_run.rb'
end
