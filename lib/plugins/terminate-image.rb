module Scli
  def self.tim
    cli = MyCLI.new
    cli.parse_options
    image_id = cli.config[:image_id] || ARGV[1]
    if image_id.nil? || !is_image_id?(image_id)
      puts "Image id provided is invalid"
    else
      response = Scli::Compute.new.delete_image(image_id)
      if response.status == 200
        puts "Image successfully terminated: #{response.body.inspect}"
      else
        puts "Image terminated failed #{response.status} with #{response.body.inspect}"
      end
    end
  end
end

PLUGINS << ["tim", "terminate-image", "Image ID (Req -m)", "scli tim 200001"]
