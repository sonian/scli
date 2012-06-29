module Scli
  def self.daddoff
    cli = MyCLI.new
    cli.parse_options
    addresses = Scli::Compute.new.list_address_offerings.body['addresses']
    table_to_print = addresses.collect do |offering|
      [offering['id'], offering['ipType'], offering['location'], offering['price']['rate'], offering['price']['countryCode'], offering['price']['currencyCode']]
    end
    table = Terminal::Table.new :title => "IP Address Offerings (#{addresses.count})".cyan, :headings => ["id".green, "IpType".green, "location".green, "price rate".green, "price country".green, "price currency".green], :rows => table_to_print
    puts table
  end
end

Scli.daddoff
