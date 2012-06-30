module Scli
  def self.ckey
    cli = MyCLI.new
    cli.parse_options
    name = cli.config[:name]
    if name.nil?
      puts "You must provide a name for the key."
    else
      response =  Scli::Compute.new.create_key(name) #Note: This method can take a pub key too, not supported yet.
      if response.status == 200
        puts "Key Created successfully... Copy private key to a safe location."
        puts "Key name: #{response.body['keyName']}"
        puts "Key Contents:\n #{response.body['keyMaterial']}"
      else
        puts "Failed with #{response.status} error of: #{response.body.inspect}"
      end
    end
  end
end

PLUGINS << ["ckey", "create-key", "Key Name (Req -n)", "scli ckey -n my_new_keypair"]
