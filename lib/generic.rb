module Scli
  class Compute
    def initialize(options={})
      cli_opts = Scli.options
      cli_opts.merge!(options)
      @fog_compute = Fog::Compute.new(:ibm_username => cli_opts[:ibm_username], :ibm_password => cli_opts[:ibm_password], :provider => 'IBM')
    end

    def servers
      @fog_compute.servers
    end
  end

  class Storage
    def initialize(options={})
      cli_opts = Scli.options
      cli_opts.merge!(options)
      @fog_storage = Fog::Storage.new(:ibm_username => cli_opts[:ibm_username], :ibm_password => cli_opts[:ibm_password], :provider => 'IBM')
    end

    def volumes
      @fog_storage.volumes
    end
  end

  def self.is_volume_id?(volume_id)
    int_volume_id = volume_id.to_i.to_s
    if int_volume_id.size >= 5
      true
    else
      false
    end
  end

  def self.is_instance_id?(instance_id)
    int_instance_id = instance_id.to_i.to_s
    if int_instance_id.size >= 6
      true
    else
      false
    end
  end

  def self.format_state(state)
    case state
    when "Active", "Attached"
      state.green
    when "Requesting", "Provisioning", "New"
      state.yellow
    else
      state.red
    end
  end

  def self.format_owner(owner)
    (owner.size > 8) ? "#{owner[0..6]}.." : owner
  end

  def self.format_ip(ip)
    return "NA".red if ip.nil? || ip == ""
    first_octet = ip.split(".").first
    first_octet == "10" ? ip.cyan : ip.magenta
  end

  def self.format_instance_id(instance_id)
    (instance_id.nil? || instance_id.to_s == "0") ? "Detached".red : instance_id.green
  end

  def self.format_type(instance_type)
    type = instance_type.split(".").first
  end

  def self.format_size(vol_size)
    if vol_size.to_i > 1024
      "#{vol_size.to_i / 1024}TB"
    else
      "#{vol_size}GB"
    end
  end

  def self.format_location(location)
    case location.to_i
    when 41
      "Raleigh"
    when 61
      "Ehningen"
    when 82
      "Boulder"
    when 101
      "Markham"
    when 121
      "Makuhari"
    when 141
      "Singapore"
    else
      location
    end
  end

  def self.print_volume(volume)
    table_to_print = []
    table_to_print << [volume.id, volume.name, format_size(volume.size), format_instance_id(volume.instance_id), volume.owner, volume.format, format_location(volume.location_id), volume.created_at, format_state(volume.state)]
    table = Terminal::Table.new :title => "Volume", :headings => ["id".green, "name".green, "size".green, "instance_id".green, "owner".green, "format".green, "location_id".green, "created_at".green, "state".green], :rows => table_to_print
    puts table
  end

  def self.print_volumes(volumes)
    table_to_print = []
    total_vol_size = 0
    volumes.each do |vol|
      table_to_print << [vol.id, vol.name, format_size(vol.size), format_instance_id(vol.instance_id), format_owner(vol.owner), vol.format, format_location(vol.location_id), vol.created_at, format_state(vol.state)]
      total_vol_size += vol.size.to_i
    end
    table = Terminal::Table.new :title => "Volumes (#{volumes.count})", :headings => ["id".green, "name".green, "size".green, "instance_id".green, "owner".green, "format".green, "location_id".green, "created_at".green, "state".green], :rows => table_to_print
    puts table
    puts "Total #{(total_vol_size.to_i / 1024.0).round(2)}Tb of storage"
  end

  def self.print_server(server)
    table_to_print = []
    table_to_print << [server.id, server.name, format_ip(server.ip), server.owner, server.vlan_id, server.volume_ids.join("\n"), format_type(server.instance_type), server.launched_at, format_location(server.location_id), format_state(server.state)]
    table = Terminal::Table.new :title => "Server".cyan, :headings => ["id".green, "name".green, "ip".green, "owner".green, "vlan_id".green, "volume_ids".green, "instance_type".green, "launched_at".green, "location_id".green, "state".green], :rows => table_to_print
    puts table
  end

  def self.print_servers(servers,single = false)
    table_to_print = []
    servers.each do |server|
      table_to_print << [server.id, server.name, format_ip(server.ip), format_type(server.instance_type), format_owner(server.owner), format_location(server.location_id), server.launched_at, format_state(server.state)]
    end
    table = Terminal::Table.new :title => "Servers (#{servers.count})".red, :headings => ["id".green, "name".green, "ip".green, "owner".green, "location_id".green, "launched_at".green, "state".green], :rows => table_to_print
    puts table
  end

  def self.pretty_print(input)
      case input.class.to_s
      when "Fog::Compute::IBM::Server"
        print_server(input)
      when "Fog::Compute::IBM::Servers"
        print_servers(input)
      when "Fog::Storage::IBM::Volume"
        print_volume(input)
      when "Fog::Storage::IBM::Volumes"
        print_volumes(input)
      when "NilClass"
        puts "Could not find the instance or volume id."
      else
        puts "Input is marked as class #{input.class} And I dont know how to handle it: #{input.inspect}"
      end
  end

  def self.read_config(config_file_path)
    options = {}
    config_file = File.open(config_file_path,'r')
    config_file.each_line do |row|
      option, data = row.split
      options[option.to_sym] = data
    end
    options
  end
end

