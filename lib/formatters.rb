module Scli
  def self.word_for_title(string)
    string.gsub("_"," ").gsub(/\w+/) do |word|
        word.capitalize
    end
  end

  def self.format_table_titles(titles)
    titles.collect do |title|
      word_for_title(title.to_s).green
    end
  end

  def self.format_state(state)
    case state
    when "Active", "Attached", "Available"
      state.green
    when "Requesting", "Provisioning", "New"
      state.yellow
    else
      state.red
    end
  end

  def self.format_is_default?(default)
    default ? "True".green : "False".red
  end

  def self.format_owner(owner)
    (owner.size > 8) ? "#{owner[0..6]}.." : owner
  end

  def self.format_name(name)
    (name.size > 34) ? "#{name[0..32]}.." : name
  end

  def self.format_description(description)
    (description.size > 14) ? "#{description[0..12]}.." : description
  end

  def self.format_capabilities(capable, full = false)
    capabilities = capable.collect do |cap|
      "#{cap['id']} => #{cap['entries']}" unless cap['entries'].size == 0 || cap.nil?
    end
    cap_print = capabilities.reject{|cap| cap.nil?}.join(",")
    full ? cap_print : "#{cap_print[0..12]}.."
  end

  def self.format_ip(ip)
    return "NA".red if ip.nil? || ip == ""
    first_octet = ip.split(".").first
    first_octet == "10" ? ip.cyan : ip.magenta
  end

  def self.format_instance_id(instance_id)
    if instance_id.class == String
      (instance_id.nil? || instance_id.to_s == "0") ? "Detached".red : instance_id.green
    elsif instance_id.nil?
      "NA".red
    else
      instance_id.join(",")
    end
  end

  def self.format_type(instance_type)
    instance_type.to_s.split(".").first
  end

  def self.format_image_instance_types(instance_types, single = false)
    supported_types = []
    instance_types.each do |it|
      supported_types << ((single) ? it.id : format_type(it.id))
    end
    (single ? supported_types.join("\n") : supported_types.join(","))
  end

  def self.format_size(vol_size)
    if vol_size.to_i > 1024
      "#{vol_size.to_i / 1024}TB"
    else
      "#{vol_size}GB"
    end
  end

  def self.format_location(location)
    case location.to_i
    when 41
      "Raleigh"
    when 61
      "Ehningen"
    when 82
      "Boulder"
    when 101
      "Markham"
    when 121
      "Makuhari"
    when 141
      "Singapore"
    else
      location
    end
  end

  def self.process_data_to_format(object, data_to_print, single = false)
    print_array = []
    data_to_print.each do |data|
      print_array << case data.to_s
      when /state/
        format_state(object.send(data))
      when /supported_instance_types/
        single ? format_image_instance_types(object.send(data), true) : format_image_instance_types(object.send(data))
      when /capabilities/
        single ? format_capabilities(object.send(data), true) : format_capabilities(object.send(data))
      when /default/
        format_is_default?(object.send(data))
      when /owner/
        single ? object.send(data) : format_owner(object.send(data))
      when /name/
        format_name(object.send(data))
      when /description/
        single ? object.send(data) : format_description(object.send(data))
      when "ip"
        format_ip(object.send(data))
      when /volume_ids/
        object.send(data).join(",")
      when /instance_id/
        format_instance_id(object.send(data))
      when /public_key/
        format_description(object.send(data))
      when /type/
        if object.send(data).class == String
          format_type(object.send(data))
        else
          object.send(data)
        end
      when /size/
        format_size(object.send(data))
      when /location/
        format_location(object.send(data))
      else
        object.send(data)
      end
    end
    print_array
  end
end
