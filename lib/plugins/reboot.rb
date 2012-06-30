module Scli
  def self.reboot
    cli = MyCLI.new
    cli.parse_options
    instance_id = cli.config[:instance_id] || ARGV[1]
    if instance_id.nil? || !is_instance_id?(instance_id)
      puts "Instance id provided is invalid"
    else
      server = Scli::Compute.new.servers.get(instance_id)
      if server.nil?
        puts "Server could not be found, check instance_id and state to ensure it can be rebooted..."
      else
        if server.reboot
          puts "Reboot successful..."
        else
          puts "Reboot failed, check instance_id and state to ensure it can be rebooted..."
        end
      end
    end
  end
end

PLUGINS << ["reboot", "", "Instance ID (Req -i)", "scli reboot 123456"]
