module Scli
  def self.dkey
    cli = MyCLI.new
    cli.parse_options
    key_id = cli.config[:key_id] || ARGV[1]
    keys = key_id.nil? ? Scli::Compute.new.keys : Scli::Compute.new.keys.get(key_id)
    print_object("Keys", keys, [:name, :default, :public_key, :instance_ids, :modified_at])
  end
end

PLUGINS << ["dkey", "describe-key, describe-keys", "Key ID (Opt -k)", "scli dkey -k 345678, scli describe-key 345678"]