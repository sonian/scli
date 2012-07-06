module Scli
  def self.cin
    cli = MyCLI.new
    cli.parse_options
    name = cli.config[:name]
    image_id = cli.config[:image_id]
    instance_type = cli.config[:instance_type]
    location_id = cli.config[:location_id]
    #Optional args
    opts = {}
    opt_merge(opts, :key_name, cli.config[:key_id])
    opt_merge(opts, :ip, cli.config[:address_id])
    opt_merge(opts, :volume_id, cli.config[:volume_id])
    opt_merge(opts, :vlan_id, cli.config[:vlan_id])
    opt_merge(opts, :secondary_ip, cli.config[:secondary_address_id])
    opt_merge(opts, :is_mini_ephemeral, cli.config[:mini_ephemeral])
    opt_merge(opts, :configuration_data, cli.config[:configuration_data])
    opt_merge(opts, :anti_collocation_instance, cli.config[:anti_colo])

    if name.nil? || location_id.nil? || image_id.nil? || instance_type.nil?
      puts "Missing one of the following (name, location_id, image_id OR instance_type)."
    else
      response = Scli::Compute.new.create_instance(name, image_id, instance_type, location_id, opts)
      if response.status == 200
        puts "Instance Created successfully: #{response.body.inspect}"
      else
        puts "Failed with #{response.status} error of: #{response.body.inspect}"
      end
    end
  end
end

PLUGINS << :separator
PLUGINS << ["cin", "create-instance", "Name (Req -n), Image ID (Req -m), Instance Type (Req -t), Location ID (Req -l),\nKey name (Req if linux -k), Addr id eth0 (Opt -a), Addr id eth1 (Opt -A),\nVlan ID (Opt -V), Volume ID (Opt -v), Mini Ephemeral (Opt --mini),\nAnti Colo (Opt --anti-colo), Img Config (Opt --config-data)", "scli cin -n 'new_inst' -i 345678 -t 'COP32.1/2048/60' -l 41"]
PLUGINS << :separator
