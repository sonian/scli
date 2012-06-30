module Scli
  def self.delvol
    cli = MyCLI.new
    cli.parse_options
    volume_id = cli.config[:volume_id] || ARGV[1]
    if volume_id.nil? || !is_volume_id?(volume_id)
      puts "Volume ID is either missing or invalid, please retry."
    else
      volume = Scli::Storage.new.volumes.get(volume_id)
      if volume.nil?
        puts "Could not find volume: #{volume_id}"
      else
        if volume.destroy
          print_volume(volume)
          puts "Is being destroyed...".red
        else
          puts "Volume could not be destroyed for some reason..."
        end
      end
    end
  end
end

PLUGINS << ["delvol", "delete-volume,terminate-volume", "Volume ID (Req -v)", "scli delvol -v 23456, scli delvol 23456"]