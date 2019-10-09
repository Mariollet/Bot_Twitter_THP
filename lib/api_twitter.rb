require 'twitter'
require 'pry'
require 'dotenv'
Dotenv.load('.env')

def login_twitter
	  client = Twitter::REST::Client.new do |config|
	  config.consumer_key        = ENV["TWITTER_CONSUMER_KEY"]
	  config.consumer_secret     = ENV["TWITTER_CONSUMER_SECRET"]
	  config.access_token        = ENV["TWITTER_ACCESS_TOKEN"]
	  config.access_token_secret = ENV["TWITTER_ACCESS_TOKEN_SECRET"]
	  end
end

def login_stream
	return Twitter::Streaming::Client.new do |config|
	  config.consumer_key        = ENV["TWITTER_CONSUMER_KEY"]
	  config.consumer_secret     = ENV["TWITTER_CONSUMER_SECRET"]
	  config.access_token        = ENV["TWITTER_ACCESS_TOKEN"]
	  config.access_token_secret = ENV["TWITTER_ACCESS_TOKEN_SECRET"]
	end
end

def Tweet(client)
	client.update('Mon premier tweet en Ruby !!!!')
end

def Follow(client)
	client.search('@the_hacking_pro').take(10).uniq.each do |tweet|
		if (tweet.user != client.user)
			client.follow(tweet.user)
			puts "The bot followed @#{tweet.user.screen_name}"
		end
	end
end

def Like(client)
	client.search('@the_hacking_pro').take(10).each do |tweet|
	client.fav tweet
	puts "The bot liked that tweet : #{tweet.text}"
	end
end

def stream (clientStream,client)
	clientStream.filter(track: "@the_hacking_pro") do |object|
		if object.is_a?(Twitter::Tweet) then
			print "Nouveau Tweet de : @#{object.user.screen_name} : "
	  		puts object.text 
	  		client.follow(object.user) if  client.user != client.user
	  		client.fav object
  		end
	end
end


def perform
client = login_twitter
clientStream = login_stream
#Tweet(client)
#Follow(client)
#Like(client)
stream(clientStream, client)
end

perform