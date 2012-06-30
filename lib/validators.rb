module Scli
  def self.yield_regular_input(argument)
    return nil if argument.nil?
    (argument[0] == "-") ? nil : argument
  end

  def self.is_address_id?(address_id)
    address_id.to_i.to_s.size >= 6
  end

  def self.is_volume_id?(volume_id)
    volume_id.to_i.to_s.size >= 5
  end

  def self.is_vlan_id?(vlan_id)
    vlan_id.to_i.to_s.size == 3
  end

  def self.is_image_id?(image_id)
    image_id.to_i.to_s.size >= 8
  end

  def self.is_instance_id?(instance_id)
    instance_id.to_i.to_s.size >= 6
  end

  def self.volume_format_valid?(format)
    valid_formats = ["EXT3", "RAW"]
    if valid_formats.include?(format)
      true
    else
      puts "The format you provided is invalid, it must be one of #{valid_formats.join(",")}"
      false
    end
  end

  def self.volume_size_valid?(size)
    valid_sizes = [60, 256, 512, 1024, 2048, 4112, 8224, 10240]
    if valid_sizes.include?(size.to_i)
      true
    else
      puts "The size you provided is invalid, it must be one of #{valid_sizes.join(",")}"
      false
    end
  end

  def self.volume_offering_valid?(offering_id)
    unless offering_id.to_s == "20035200"
      puts "=" * 60
      puts "WARN: IBM has many offering ID's for volumes, however most do not support large blocks and they seem to be migrating away from using them."
      puts "WARN: Every volume created in the WebUI uses a offering id of 20035200, so you probably want to use that."
      puts "=" * 60
    end
    true
  end
end
