module Scli
  def self.dint
    instance_types = []

    instance_types << "COP32.1/2048/60"
    instance_types << "BRZ32.1/2048/60*175"
    instance_types << "SLV32.2/4096/60*350"
    instance_types << "GLD32.4/4096/60*350"

    instance_types << "COP64.2/4096/60"
    instance_types << "BRZ64.2/4096/60*500*350"
    instance_types << "SLV64.4/8192/60*500*500"
    instance_types << "GLD64.8/16384/60*500*500"
    instance_types << "PLT64.16/16384/60*500*500*500*500"

    table_to_print = []

    instance_types.each do |inst_type|
      name, ram, disks = inst_type.split("/")
      color = name.slice!(0..2)
      bits, cpus = name.split(".")
      disk = disks.split("*")
      total_ephemeral_size = disk.inject{|sum,x| sum.to_i + x.to_i }
      total_ephemeral_non_root = (disk.count > 1) ? (disk.drop(1).inject{|sum,x| sum.to_i + x.to_i }) : 0
      total_ephemeral_devices = (disk.count > 1) ? (disk.drop(1).count) : 0
      table_to_print << [inst_type, color, bits, cpus, ram, total_ephemeral_size, total_ephemeral_non_root, total_ephemeral_devices]
    end

    table = Terminal::Table.new :title => "Instance Types".cyan, :headings => ["id".green, "color".green, "bits".green, "CPU(s)".green, "RAM".green, "Total Ephemeral".green, "Total Ephemeral (Non-Root)".green, "Ephemeral devices (Non-Root)".green], :rows => table_to_print
    puts table
    puts "Note: This table is not from an API, its simply a helper for the non-rememberable naming IBM gives their instances - List may update/change."
  end
end

PLUGINS << ["dint", "describe-instance-types", "", "scli dint"]
