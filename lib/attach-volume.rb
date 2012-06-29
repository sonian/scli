module Scli
  def self.attvol
    cli = MyCLI.new
    cli.parse_options
    volume_id = cli.config[:volume_id]
    instance_id = cli.config[:instance_id]
    if volume_id.nil? || instance_id.nil?
      puts "Instance and volume id's are required, please retry."
    else
      server = Scli::Compute.new.servers.get(instance_id)
      volume = Scli::Storage.new.volumes.get(volume_id)
      if server.nil?
        puts "Could not find server: #{instance_id}"
      elsif volume.nil?
        puts "Could not find volume: #{volume_id}"
      else
        if server.attach(volume_id.to_i) # Note: attach() takes a string, not an object
          print_volumes(volume)
          puts "Is being attached to instance:".red
          print_servers(server)
        else
          puts "Volume could not be attached for some reason..."
        end
      end
    end
  end
end

Scli.attvol
