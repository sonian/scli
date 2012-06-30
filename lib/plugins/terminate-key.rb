module Scli
  def self.tkey
    cli = MyCLI.new
    cli.parse_options
    name = cli.config[:name] || yield_regular_input(ARGV[1])
    if name.nil?
      puts "Key name not provided"
    else
      response = Scli::Compute.new.delete_key(name)
      if response.status == 200
        puts "Key successfully terminated: #{response.body.inspect}"
      else
        puts "Key termination failed #{response.status} with #{response.body.inspect}"
      end
    end
  end
end

PLUGINS << ["tkey", "terminate-key", "Name (Req -n)", "scli tkey 200001"]
