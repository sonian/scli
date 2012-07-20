module Scli
  def self.detvol
    cli = MyCLI.new
    cli.parse_options
    volume_id = cli.config[:volume_id] || ARGV[1]
    instance_id = cli.config[:instance_id]
    if volume_id.nil?
      puts "Volume ID is required, please retry."
    else
      volume = Scli::Storage.new.volumes.get(volume_id)
      instance_id = volume.instance_id if instance_id.nil?
      server = Scli::Compute.new.servers.get(instance_id)
      if server.nil?
        puts "Could not find server: #{instance_id}"
      elsif volume.nil?
        puts "Could not find volume: #{volume_id}"
      else
        if server.detach(volume_id) # Note: detach() takes a string, not an object
          print_volumes(volume)
          puts "Is being detached from instance:".red
          print_servers(server)
        else
          puts "Volume could not be detached for some reason..."
        end
      end
    end
  end
end

PLUGINS << ["detvol", "detach-volume", "Volume ID (Req -v), Instance ID (Opt -i)", "scli detvol 23456"]
