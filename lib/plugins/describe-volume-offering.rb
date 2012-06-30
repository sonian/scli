module Scli
  def self.dvoloff
    cli = MyCLI.new
    cli.parse_options
    offerings = Scli::Storage.new.list_offerings.body['volumes']
    table_to_print = offerings.collect do |offering|
      [offering['id'], offering['name'], format_location(offering['location']), offering['price']['rate'], offering['price']['currencyCode'], offering['price']['unitOfMeasure'], offering['formats'].collect{|format| format['id']}.join(","), offering['capacity']]
    end
    table = Terminal::Table.new :title => "Volume Offerings (#{offerings.count})".cyan, :headings => ["id".green, "Name".green, "location".green, "price rate".green, "price currency".green, "Price Measure".green, "Formats".green, "Capacity".green], :rows => table_to_print
    puts table
  end
end

PLUGINS << ["dvoloff", "describe-volume-offerings", "", "scli dvoloff"]