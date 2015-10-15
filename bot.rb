require "slack"
require "yaml"
require "google/api_client"
require "google_drive"

$secret_config = YAML.load_file("./secret.yml")

def slack_hello_world
	Slack.configure do |config|
		config.token = $secret_config["auth"]["slack"]["myslackbot_token"]
	end

	client = Slack::Web::Client.new

	puts client.auth_test

	channel = client.channels_list["channels"].find { |c| c["name"] == "random" }
	puts channel

	# puts client.channels_join(name: channel["name"])
	puts "-------"

	puts client.chat_postMessage(channel: channel["id"], text: "@greg Hello World", link_names: 1)
end

def google_drive_hello_world
	access_token = google_drive_get_access_token
	session = GoogleDrive.login_with_oauth(access_token)
	sheet = session.spreadsheet_by_key("1Ip78CnBjnryatAe877fmGR2q5GjaSY70AGqj9qgC2RM").worksheets[0]
	puts sheet[1, 1]
end

def google_drive_get_refresh_token
	client = Google::APIClient.new
	auth = client.authorization
	auth.client_id = $secret_config["auth"]["google"]["client_id"]
	auth.client_secret = $secret_config["auth"]["google"]["client_secret"]
	auth.scope = [
	  "https://www.googleapis.com/auth/drive",
	  "https://spreadsheets.google.com/feeds/"
	]
	auth.redirect_uri = "urn:ietf:wg:oauth:2.0:oob"
	print("1. Open this page:\n%s\n\n" % auth.authorization_uri)
	print("2. Enter the authorization code shown in the page: ")
	auth.code = $stdin.gets.chomp
	auth.fetch_access_token!

	print("3. This is your refresh token: %s\n\n" % auth.refresh_token)
end

def google_drive_get_access_token
	client = Google::APIClient.new
    auth = client.authorization
    auth.client_id = $secret_config["auth"]["google"]["client_id"]
    auth.client_secret = $secret_config["auth"]["google"]["client_secret"]
    auth.scope = [
      "https://www.googleapis.com/auth/drive",
      "https://spreadsheets.google.com/feeds/"
    ]
    auth.redirect_uri = "urn:ietf:wg:oauth:2.0:oob"
    auth.refresh_token = $secret_config["auth"]["google"]["refresh_token"]
    auth.fetch_access_token!
    auth.access_token
end

# google_drive_get_refresh_token
google_drive_hello_world