module Scli
  def self.gco
    cli = MyCLI.new
    cli.parse_options
    instance_id = cli.config[:instance_id] || yield_regular_input(ARGV[1])
    if instance_id.nil? || !is_instance_id?(instance_id)
      puts "An invalid instance id was provided."
    else
      response = Scli::Compute.new.get_instance_logs(instance_id)
      if response.status == 200
        puts "Console log output:"
        puts "#{response.body['logs'].join("\n")}"
      else
        puts "Failed with #{response.status} error of: #{response.body.inspect}"
      end
    end
  end
end
  PLUGINS << ["gco", "get-console-output", "Instance ID (Req -i)", "scli gco 123456"]

