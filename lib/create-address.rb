module Scli
  def self.cadd
    cli = MyCLI.new
    cli.parse_options
    offering_id = cli.config[:offering_id]
    location_id = cli.config[:location_id]
    vlan_id = cli.config[:vlan_id]
    if offering_id.nil? || location_id.nil?
      puts "No offering and or location id was found, please retry"
    else
      options = vlan_id.nil? ? {} : {:vlan_id => vlan_id}
      response =  Scli::Compute.new.create_address(location_id, offering_id, options)
      if response.status == 200
        puts "IP Created successfully: #{response.body.inspect}"
      else
        puts "Failed with #{response.status} error of: #{response.body.inspect}"
      end
    end
  end
end

Scli.cadd
