module Scli
  def self.dvol
    cli = MyCLI.new
    cli.parse_options
    volume_id = cli.config[:volume_id] || ARGV[1]
    if volume_id.nil?
      print_volumes(Scli::Storage.new.volumes)
    else
      if is_volume_id?(volume_id)
        print_volumes(Scli::Storage.new.volumes.get(volume_id))
      else
        puts "Volume id provided is invalid"
      end
    end
  end
end

PLUGINS << ["dvol", "describe-volume, describe-volumes", "Volume ID (Opt -v)", "scli dvol 23456"]