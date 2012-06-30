module Scli
  def self.tad
    cli = MyCLI.new
    cli.parse_options
    address_id = cli.config[:address_id] || ARGV[1]
    if address_id.nil? || !is_address_id?(address_id)
      puts "Address id provided is invalid"
    else
      response = Scli::Compute.new.delete_address(address_id)
      if response.status == 200
        puts "Address successfully terminated: #{response.body.inspect}"
      else
        puts "Address terminated failed #{response.status} with #{response.body.inspect}"
      end
    end
  end
end

PLUGINS << ["tad", "terminate-address", "Address ID (Req -a)", "scli tad 200001"]
