module Scli
  def self.dloc
    cli = MyCLI.new
    cli.parse_options
    location_id = cli.config[:location_id] || ARGV[1]
    locations = location_id.nil? ? Scli::Compute.new.locations : Scli::Compute.new.locations.get(location_id)
    print_object("Locations", locations, [:id, :name, :location, :capabilities, :description])
  end
end

PLUGINS << ["dloc", "describe-location, describe-locations", "Location ID (Opt -c)", "scli dloc -c 345, scli describe-location 345"]