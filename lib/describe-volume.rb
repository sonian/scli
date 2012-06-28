module Scli
  def self.dvol
    cli = MyCLI.new
    cli.parse_options
    volume_id = cli.config[:volume_id] || ARGV[1]
    if volume_id.nil?
      pretty_print(Scli::Storage.new.volumes)
    else
      if is_volume_id?(volume_id)
        pretty_print(Scli::Storage.new.volumes.get(volume_id))
      else
        puts "Volume id provided is invalid"
      end
    end
  end
end

Scli.dvol
