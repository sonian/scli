module Scli
  def self.tin
    cli = MyCLI.new
    cli.parse_options
    instance_id = cli.config[:instance_id] || ARGV[1]
    if instance_id.nil? || !is_instance_id?(instance_id)
      puts "Instance id provided is invalid"
    else
      server = Scli::Compute.new.servers.get(instance_id)
      if server.nil?
        puts "Could not find server #{instance_id}, please check instance_id and state and retry."
      else
        if server.destroy
          print_server(server)
          puts "Is being destroyed...".red
        else
          puts "Could not destroy server #{instance_id}, please check instance_id and state and retry."
        end
      end
    end
  end
end

Scli.tin
