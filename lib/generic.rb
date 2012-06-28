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
    when "Active"
      state.green
    when "Requesting", "Provisioning"
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

  def self.format_type(instance_type)
    type = instance_type.split(".").first
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

  def self.print_server(server,single = false)
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

