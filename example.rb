#!/usr/bin/env ruby

$LOAD_PATH.unshift(File.expand_path("lib", __dir__))

require_relative 'lib/vibe_if'

VibeIf.configure do |config|
  config.openai_api_key = ENV['OPENAI_API_KEY']
end

class Review
  attr_reader :text, :rating, :restaurant_tier

  def initialize(text, rating, restaurant_tier)
    @text = text
    @rating = rating
    @restaurant_tier = restaurant_tier
  end

  def analyze_sentiment
    puts "\n🍽️  RESTAURANT REVIEW ANALYSIS"
    puts "Rating: #{@rating}/5 stars | Restaurant: #{@restaurant_tier}"
    puts "Text: \"#{@text}\"\n"
    
    if vibe_if "this review expresses genuine disappointment despite the neutral rating"
      puts "⚠️  ACTION: Escalating to management - hidden negative sentiment detected!"
      puts "💡 AI detected frustration that star rating doesn't capture\n"
    else
      puts "✅ Review sentiment matches rating - no action needed\n"
    end
  end
end

class BlogPost
  attr_reader :title, :content, :author_reputation, :engagement_score

  def initialize(title, content, author_reputation, engagement_score)
    @title = title
    @content = content
    @author_reputation = author_reputation
    @engagement_score = engagement_score
  end

  def moderate_content
    puts "\n📝 CONTENT MODERATION SYSTEM"
    puts "Title: #{@title}"
    puts "Author Rep: #{@author_reputation} | Engagement: #{@engagement_score}%"
    puts "Content: \"#{@content[0..80]}...\"\n"
    
    if vibe_if "this content provides valuable, evidence-based information"
      puts "✅ APPROVED: Promoting to featured content"
      puts "🚀 High-quality content detected by AI\n"
    else
      puts "❌ FLAGGED: Content appears to make questionable claims"
      puts "🔍 Demoting in search results\n"
    end
  end
end

class CustomerMessage
  attr_reader :text, :context, :customer_tier, :previous_interactions

  def initialize(text, context, customer_tier, previous_interactions)
    @text = text
    @context = context
    @customer_tier = customer_tier
    @previous_interactions = previous_interactions
  end

  def analyze_intent
    puts "\n💬 CUSTOMER SUPPORT INTELLIGENCE"
    puts "Customer: #{@customer_tier} | Context: #{@context}"
    puts "History: #{@previous_interactions} previous interactions"
    puts "Message: \"#{@text}\"\n"
    
    if vibe_if "this customer is expressing subtle dissatisfaction"
      puts "🎯 INSIGHT: Customer dissatisfaction detected beyond surface meaning"
      puts "📞 Triggering proactive outreach campaign\n"
    else
      puts "😊 Customer seems satisfied - standard follow-up scheduled\n"
    end
  end
end

def run_examples
  puts "🤖 VibeIf AI-Powered Decision Engine Demo"
  puts "=" * 50

  reviews = [
    ["The food was okay but the service was incredibly rude and slow", 3, "fine_dining"],
    ["Amazing experience! Will definitely come back!", 5, "casual"],
    ["It's fine I guess, nothing special but not bad either", 3, "fast_food"]
  ]

  reviews.each do |text, rating, tier|
    Review.new(text, rating, tier).analyze_sentiment
  end

  posts = [
    ["Proven Science-Based Nutrition Tips", "Based on peer-reviewed research from Harvard Medical School, here are evidence-based approaches to nutrition...", 95, 78],
    ["LOSE 30 POUNDS IN 7 DAYS!", "This miracle berry from the Amazon will melt fat instantly! Doctors hate this one weird trick...", 12, 34],
    ["Understanding Ruby Metaprogramming", "Let's explore how Ruby's metaclass system works and practical applications in real-world code...", 87, 92]
  ]

  posts.each do |title, content, rep, engagement|
    BlogPost.new(title, content, rep, engagement).moderate_content
  end

  messages = [
    ["I guess the product is fine for what it is", "post_purchase_survey", "premium", 3],
    ["This is exactly what I was looking for, thank you!", "support_chat", "basic", 1],
    ["The quality could be better considering the price point", "product_review", "vip", 5]
  ]

  messages.each do |text, context, tier, interactions|
    CustomerMessage.new(text, context, tier, interactions).analyze_intent
  end

  puts "🎉 Demo complete! VibeIf analyzed #{reviews.length + posts.length + messages.length} items using natural language AI."
end

if ENV['OPENAI_API_KEY']
  run_examples
else
  puts "Please set OPENAI_API_KEY environment variable to run this example"
end
