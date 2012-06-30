module Scli
  def self.dim
    cli = MyCLI.new
    cli.parse_options
    image_id = cli.config[:image_id] || yield_regular_input(ARGV[1])
    private_imgs = cli.config[:private]
    if image_id.nil?
      images = private_imgs ? Scli::Compute.new.images.reject{|img| img.visibility != "PRIVATE"} : Scli::Compute.new.images
      print_object("Images", images, [:id, :name, :architecture, :platform, :visibility, :supported_instance_types, :description, :location, :owner, :created_at, :state])
    else
      if is_image_id?(image_id)
        print_object("Image", Scli::Compute.new.images.get(image_id), [:id, :name, :architecture, :platform, :visibility, :supported_instance_types, :description, :location, :owner, :created_at, :state])
      else
        puts "Image id provided is invalid"
      end
    end
  end
end

PLUGINS << ["dim", "describe-image, describe-images", "Image ID (Opt -m), Private Only (Opt -p)", "scli dim -m 34567, scli describe-image 34567"]
