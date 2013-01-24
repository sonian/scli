module Scli
  class Compute
    def initialize(options={})
        cli_opts = Scli.options
        cli_opts.merge!(options)
        ibm_user = (Scli.env_populated?) ? ENV['IBM_SC_USERNAME'] : cli_opts[:ibm_username]
        ibm_pass = (Scli.env_populated?) ? ENV['IBM_SC_PASSWORD'] : cli_opts[:ibm_password]
        @fog_compute = Fog::Compute.new(:ibm_username => ibm_user, :ibm_password => ibm_pass, :provider => 'IBM')
    end

    def method_missing(method, *args, &block)
        @fog_compute.send(method, *args, &block)
    end
  end

  class Storage
    def initialize(options={})
        cli_opts = Scli.options
        cli_opts.merge!(options)
        ibm_user = (Scli.env_populated?) ? ENV['IBM_SC_USERNAME'] : cli_opts[:ibm_username]
        ibm_pass = (Scli.env_populated?) ? ENV['IBM_SC_PASSWORD'] : cli_opts[:ibm_password]
        @fog_storage = Fog::Storage.new(:ibm_username => ibm_user, :ibm_password => ibm_pass, :provider => 'IBM')
    end

    def method_missing(method, *args, &block)
        @fog_storage.send(method, *args, &block)
    end
  end

  def self.config_file_exists?(config_file_path)
    File.exists?(File.expand_path(config_file_path))
  end

  def self.generate_config_file(config_file_path)
    puts "Config file #{config_file_path} does not exist, let's create it."
    puts "What is your IBM SC Username?"
    ibm_username = $stdin.gets
    puts "What is your IBM SC Password?"
    ibm_password = $stdin.gets
    Dir.mkdir(File.expand_path(File.dirname(config_file_path))) unless File.exists?(File.expand_path(File.dirname(config_file_path)))
    ibm_config = File.open(File.expand_path(config_file_path), "w")
    ibm_config.puts "ibm_username #{ibm_username}"
    ibm_config.puts "ibm_password #{ibm_password}"
    ibm_config.close
    puts "Config file written."
  end

  def self.print_object(title, objects, data_to_print, options = {})
    table_to_print = []
    if objects.respond_to?('each') # Its not a single object
      title = title + "(#{objects.count})"
      objects.each do |object|
        table_to_print << process_data_to_format(object, data_to_print)
        table_to_print << :separator if options[:separator]
      end
    else
        table_to_print << process_data_to_format(objects, data_to_print, true)
    end
    table = Terminal::Table.new :title => title.cyan, :headings => format_table_titles(data_to_print), :rows => table_to_print
    puts table
  end

  def self.print_volumes(volumes)
    print_object("Volumes", volumes, [:id, :name, :size, :instance_id, :owner, :format, :location_id, :offering_id, :created_at, :state])
    if volumes.class.to_s == "Fog::Storage::IBM::Volumes"
      total_vol_size = 0
      volumes.each do |vol|
        next if vol.size.nil?
        total_vol_size += vol.size.to_i
      end
      puts "Total #{(total_vol_size.to_i / 1024.0).round / 1.0}Tb of storage"
    end
  end

  def self.print_servers(servers)
    print_object("Servers", servers, [:id, :name, :ip, :owner, :vlan_id, :volume_ids, :instance_type, :launched_at, :location_id, :state])
  end

  def self.opt_merge(options, name, data)
    options.merge!({name => data}) unless data.nil?
  end

  def self.env_populated?
    (ENV['IBM_SC_USERNAME'].nil? || ENV['IBM_SC_PASSWORD'].nil?) ? false : (!ENV['IBM_SC_USERNAME'].empty? && !ENV['IBM_SC_PASSWORD'].empty?)
  end

  def self.read_config(config_file_path)
    options = {}
    if File.exists?(config_file_path)
      config_file = File.open(config_file_path,'r')
      config_file.each_line do |row|
        option, data = row.split
        options[option.to_sym] = data
      end
    end
    options
  end
end

