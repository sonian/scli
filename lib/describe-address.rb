module Scli
  def self.dadd
    cli = MyCLI.new
    cli.parse_options
    address_id = cli.config[:address_id] || ARGV[1]
    if address_id.nil? || is_address_id?(address_id)
      addresses = (address_id.nil?) ? Scli::Compute.new.addresses : Scli::Compute.new.addresses.get(address_id)
      print_object("Addresses", addresses, [:id, :location, :ip, :state, :instance_id, :hostname, :mode, :owner])
    else
      puts "Got an invalid address id, please retry."
    end
  end
end

Scli.dadd
