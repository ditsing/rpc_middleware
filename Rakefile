desc "Update rpc module list"
task :update do
	require_relative 'lib/rpc_module'
	$mod_list = []
	module RPCModule
		def RPCModule.extended mod
			$mod_list.push mod
		end
	end

	require_relative 'rpc_module_list_template'

	mod_extend_list = $mod_list.collect { |mod| "\textend " + mod.to_s + "\n"}

	former_part = []
	later_part = []

	delimeter = '##@RPCModuleList' + "\n"
	template_file_name = 'rpc_module_list_template.rb'
	base_file_name = 'rpc_module_list.rb'
	old_file_name = base_file_name
	new_file_name = base_file_name + '.new'

	File.open( template_file_name, 'r') do |file|
		file.each { |line| break if line =~ /#{delimeter}/; former_part.push line}
			file.each { |line| break if line =~ /#{delimeter}/}
			file.each { |line| later_part.push line}
	end

	File.open( new_file_name, 'w') do |file|
		former_part.each { |line| file.write line; puts line}
		file.write delimeter
		puts delimeter
		mod_extend_list.each { |line| file.write line; puts line}
		file.write delimeter
		puts delimeter
		later_part.each { |line| file.write line; puts line}
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
