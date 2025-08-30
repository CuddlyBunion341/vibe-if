#!/usr/bin/env ruby

$LOAD_PATH.unshift(File.expand_path("lib", __dir__))

require_relative 'lib/vibe_if'

VibeIf.configure do |config|
  config.openai_api_key = ENV['OPENAI_API_KEY']
end

class BlogPost
  def initialize(title, views, comments_count, author_karma)
    @title = title
    @views = views
    @comments_count = comments_count
    @author_karma = author_karma
  end

  def moderate_content
    puts "Analyzing post: #{@title}"
    
    vibe_if "the post is popular and engaging" do
      puts "Promoting this post!"
    end

    vibe_if "the post has low engagement or seems spammy" do
      puts "Flagging for review"
    end

    vibe_if "the author has high karma and the post has good metrics" do
      puts "Adding to featured posts"
    end
  end
end

class User
  def initialize(name, age, subscription_type, last_login_days_ago)
    @name = name
    @age = age
    @subscription_type = subscription_type
    @last_login_days_ago = last_login_days_ago
  end

  def send_notifications
    puts "Checking user: #{@name}"
    
    vibe_if "user is young and hasn't logged in recently" do
      puts "Sending re-engagement notification"
    end

    vibe_if "user is a premium subscriber" do
      puts "Sending exclusive content update"
    end

    vibe_if "user might be churning based on their activity" do
      puts "Sending retention campaign"
    end
  end
end

def run_examples
  post1 = BlogPost.new("10 Ruby Tips", 1500, 25, 850)
  post1.moderate_content

  post2 = BlogPost.new("Buy my course NOW!!!", 50, 2, 10)
  post2.moderate_content

  user1 = User.new("Alice", 22, "free", 7)
  user1.send_notifications

  user2 = User.new("Bob", 35, "premium", 1)
  user2.send_notifications
end

if ENV['OPENAI_API_KEY']
  run_examples
else
  puts "Please set OPENAI_API_KEY environment variable to run this example"
end
