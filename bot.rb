require "slack"
require "yaml"

secret_config = YAML.load_file("./secret.yml")

Slack.configure do |config|
	config.token = secret_config["auth"]["myslackbot_token"]
end

client = Slack::Web::Client.new

puts client.auth_test

channel = client.channels_list["channels"].find { |c| c["name"] == "random" }
puts channel

# puts client.channels_join(name: channel["name"])
puts "-------"

puts client.chat_postMessage(channel: channel["id"], text: "@greg Hello World", link_names: 1)