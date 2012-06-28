module Scli
  def self.din
    cli = MyCLI.new
    cli.parse_options
    instance_id = cli.config[:instance_id] || ARGV[1]
    if instance_id.nil?
      pretty_print(Scli::Compute.new.servers)
    else
      if is_instance_id?(instance_id)
        pretty_print(Scli::Compute.new.servers.get(instance_id))
      else
        puts "Instance id provided is invalid"
      end
    end
  end
end

Scli.din
