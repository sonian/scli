require 'rubygems'
require 'mixlib/cli'
require 'fog'
require 'colored'
require 'terminal-table'
require 'validators'
require 'formatters'
require 'generic'

PLUGINS = []

class MyCLI
  include Mixlib::CLI

  option :config_file,
    :short => "-C CONFIG",
    :long  => "--config CONFIG",
    :default => '~/.scli/config.rb',
    :description => "The configuration file to use"

  option :address_id,
    :short => "-a ADDRESS",
    :long => "--address-id ADDRESS",
    :description => "IP Address ID to use"

  option :instance_id,
    :short => "-i INSTANCE",
    :long => "--instance-id INSTANCE",
    :description => "Instance ID to use"

  option :volume_id,
    :short => "-v VOLUME",
    :long => "--volume-id VOLUME",
    :description => "Volume ID to use"

  option :instance_type,
    :short => "-t TYPE",
    :long => "--instance-type TYPE",
    :description => "Instance Type (e.g. COP32.1/2048/60)"

  option :image_id,
    :short => "-m IMAGE",
    :long => "--image-id IMAGE",
    :description => "Image ID to use"

  option :key_id,
    :short => "-k IMAGE",
    :long => "--key-id KEY",
    :description => "Key ID to use"

  option :offering_id,
    :short => "-o OFFERING",
    :long => "--offering-id OFFERING",
    :description => "Offering ID to use"

  option :vlan_id,
    :short => "-V VLAN",
    :long => "--vlan-id VLAN",
    :description => "Vlan ID to use"

  option :location_id,
    :short => "-l LOCATION",
    :long => "--location-id LOCATION",
    :description => "Location ID to use"

  option :name,
    :short => "-n NAME",
    :long => "--name NAME",
    :description => "Name to use"

  option :size,
    :short => "-s SIZE",
    :long => "--size SIZE",
    :description => "Size to use"

  option :format,
    :short => "-f FORMAT",
    :long => "--format FORMAT",
    :description => "Format to use (EXT3, RAW)"

  option :private,
    :short => "-p",
    :long => "--private",
    :boolean => true,
    :description => "Only show private images, etc"

  option :mini_ephemeral,
    :long => "--mini",
    :boolean => true,
    :description => "(Create instance only) Set mini ephemeral)"

  option :configuration_data,
    :long => "--config-data DATA",
    :description => "(Create instance only) Extra config data required by image"

  option :anti_colo,
    :long => "--anti-colo INST_ID",
    :description => "(Create instance only) Instance ID to anti-colo against"

  option :secondary_address_id,
    :short => "-A SADDRESS",
    :long => "--secondary-address-id SADDRESS",
    :description => "(Create instance only) IP To use for eth1"

  option :help,
    :short => "-h",
    :long => "--help",
    :description => "SCLI Help",
    :on => :tail,
    :boolean => true,
    :show_options => true,
    :exit => 0

end

module Scli
  def self.options
    cli = MyCLI.new
    cli.parse_options
    cli.config.merge!(read_config(File.expand_path(cli.config[:config_file])) || {})
  end
end

module Scli
  class Main
    def self.run
      cli = MyCLI.new
      cli.parse_options

      Scli.generate_config_file(cli.config[:config_file]) unless Scli.config_file_exists?(cli.config[:config_file]) || Scli.env_populated?

      Dir.glob("#{File.dirname(__FILE__)}/plugins/*").each do |plugin|
        require plugin
      end

      help_table = Terminal::Table.new :title => "Help", :headings => ["Command", "Aliases", "Arguments", "Examples"], :rows => PLUGINS

      #
      # every array in plugins contains the main command [0], comma seperated command aliases [1], options [2] and examples [3]. So we match on [0] or [1] below.
      #
      begin
        plugin_executed = false
        PLUGINS.each do |plugin|
          commands = [plugin[0]] + plugin[1].split(",")
          if commands.include?(ARGV[0])
            Scli.send(plugin[0])
            plugin_executed = true
          end
        end

        unless plugin_executed || !ARGV[0] == "help"
        puts help_table
        puts "\n Run scli -h to get CLI Args"
        end

      rescue Excon::Errors::InternalServerError => e
        puts "Got an internal server error while trying to talk to IBM: #{e.response.body}"
      rescue Excon::Errors::PreconditionFailed => e
        puts "A precondition failed while trying to do our API Request: #{e.response.body}"
      rescue Excon::Errors::SocketError => e
        puts "Could not connect to IBM: #{e}"
      rescue Excon::Errors::Unauthorized => e
        puts "You were not authorized to access a resource, Are you sure its owned by the account in your config file? -- #{e.response.body}"
      rescue Exception => e
        if e.methods.include?(:response)
          puts "Fog API Took an exception while speaking to IBM: #{e.response.body}"
        else
          puts "Took an exception, You probably put an invalid instance, volume or address id in as a command line argument, Check to make sure it really exists and retry."
          puts "#{e.backtrace.join("\n")} -- #{e.message}"
        end
      end
    end
  end
end
