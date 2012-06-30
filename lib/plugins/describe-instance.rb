module Scli
  def self.din
    cli = MyCLI.new
    cli.parse_options
    instance_id = cli.config[:instance_id] || ARGV[1]
    if instance_id.nil?
      print_servers(Scli::Compute.new.servers)
    else
      if is_instance_id?(instance_id)
        print_servers(Scli::Compute.new.servers.get(instance_id))
      else
        puts "Instance id provided is invalid"
      end
    end
  end
end

PLUGINS << ["din", "describe-instances, describe-instance", "Instance ID (Opt -i)", "scli din, scli din 123456"]