module Scli
  def self.dim
    cli = MyCLI.new
    cli.parse_options
    image_id = cli.config[:image_id] || ARGV[1]
    if image_id.nil?
      print_object("Images", Scli::Compute.new.images, [:id, :name, :architecture, :platform, :visibility, :supported_instance_types, :description, :location, :owner, :created_at, :state])
    else
      if is_image_id?(image_id)
        print_object("Image", Scli::Compute.new.images.get(image_id), [:id, :name, :architecture, :platform, :visibility, :supported_instance_types, :description, :location, :owner, :created_at, :state])
      else
        puts "Image id provided is invalid"
      end
    end
  end
end

Scli.dim
