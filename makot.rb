require 'rubygems'
require 'twitter'
require 'oauth'

CONSUMER_KEY = "MvDn77aYaBk9JDhxCWYBg"
CONSUMER_SECRET = "TPxDW8BPJriMQyexNjQ6IfuWA6QG2vLksgH4Y0R4eo" 

makotConfig = {}

if (File.exist?("save.dat")) 
	confFile = File.open("save.dat")
	makotConfig = Marshal.load(confFile.read)
else
	consumer = OAuth::Consumer.new(CONSUMER_KEY, CONSUMER_SECRET, :site => "http://twitter.com")

	request_token = consumer.get_request_token 
	# twitterに対してrequestトークンを要求

	url = request_token.authorize_url # requrest tokenをもとに認証URLを生成
	
	system("cygstart #{url}")

	puts "Enter PIN Code"
	
	while line = STDIN.gets
		if /^[0-9]+$/ =~ line
			line.strip!
		
			access_token = request_token.get_access_token(:oauth_verifier => line )
			
			makotConfig["access_token"] = access_token.token
			makotConfig["access_secret"] = access_token.secret
			
			confTxt = Marshal.dump(makotConfig)
			
			confFile = File.open("save.dat","w")
			
			confFile.write confTxt
			confFile.close
			break
		end
	end
end


# access_key, access_secret, consumer_key, consumer_secretをもとにAPIにアクセスする
Twitter.configure do |config|
  config.consumer_key = CONSUMER_KEY
  config.consumer_secret = CONSUMER_SECRET
  config.oauth_token = makotConfig["access_token"]
  config.oauth_token_secret = makotConfig["access_secret"]
end

# Initialize your Twitter client
client = Twitter::Client.new

client.update("テスト投稿２！")