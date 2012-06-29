module Scli
  def self.cvol
    cli = MyCLI.new
    cli.parse_options
    offering_id = cli.config[:offering_id]
    location_id = cli.config[:location_id]
    format = cli.config[:format]
    size = cli.config[:size]
    name = cli.config[:name]

    if offering_id.nil?
      puts "You did not provide an offering id, using a generic id of 20035200."
      offering_id = 20035200
    end

    if format.nil? || name.nil? || size.nil? || location_id.nil? || offering_id.nil?
      puts "Missing offering_id or location_id or format or size or name, please retry."
    else
      if volume_format_valid?(format) && volume_size_valid?(size) && volume_offering_valid?(offering_id)
        response =  Scli::Storage.new.create_volume(name, offering_id, format, location_id, size)
        if response.status == 200
          puts "Volume Created successfully: #{response.body.inspect}"
        else
          puts "Failed with #{response.status} error of: #{response.body.inspect}"
        end
      end
    end
  end
end

Scli.cvol
