module Scli
  def self.dvlan
    cli = MyCLI.new
    cli.parse_options
    vlan_id = cli.config[:vlan_id] || ARGV[1]
    if vlan_id.nil?
      print_object("VLANs", Scli::Compute.new.vlans, [:id, :name, :location])
    else
      if is_vlan_id?(vlan_id)
        print_object("VLANs", Scli::Compute.new.vlans.get(vlan_id), [:id, :name, :location])
      else
        puts "Got an invalid VLAN id, please retry."
      end
    end
  end
end

PLUGINS << ["dvlan", "describe-vlan, describe-vlans", "Vlan ID (Opt -V)", "scli dvlan -V 345, scli describe-vlan 345"]
