require "vibe_if/version"
require "vibe_if/configuration"
require "vibe_if/evaluator"

# VibeIf provides natural language conditional evaluation using AI.
# It allows you to write conditions in plain English that are evaluated
# based on the current object's state.
module VibeIf
  class << self
    # Returns the current configuration instance.
    # 
    # @return [VibeIf::Configuration] the configuration object
    def configuration
      @configuration ||= Configuration.new
    end

    # Configures VibeIf by yielding the configuration object to a block.
    # 
    # @yield [config] the configuration object to modify
    # @yieldparam config [VibeIf::Configuration] the configuration instance
    # 
    # @example
    #   VibeIf.configure do |config|
    #     config.openai_api_key = "your-api-key"
    #     config.model = "gpt-4"
    #   end
    def configure
      yield(configuration)
    end
  end
end

class Object
  # Evaluates a natural language condition against the current object's state.
  # Uses AI to determine if the condition is true or false based on instance variables.
  # 
  # @param condition_description [String] the condition to evaluate in natural language
  # @yield optional block to execute if condition is true
  # @return [Boolean] true if condition evaluates to true, false otherwise
  # 
  # @example Sentiment-based content promotion
  #   review = Review.new(
  #     text: "The food was okay but the service was incredibly rude and slow",
  #     rating: 3,
  #     restaurant_tier: "premium"
  #   )
  #   review.vibe_if("this review expresses genuine disappointment despite the neutral rating") do
  #     review.escalate_to_management!
  #   end
  #   # => true (LLM detects negative sentiment despite 3-star rating)
  # 
  # @example Context-aware content quality assessment
  #   article = BlogPost.new(
  #     title: "10 Ways to Lose Weight Fast",
  #     content: "Drink this magic tea and lose 20 pounds in 3 days!",
  #     author_credentials: "fitness_blogger",
  #     word_count: 500
  #   )
  #   unless article.vibe_if("this content provides valuable, evidence-based information")
  #     article.demote_in_search!
  #   end
  #   # => false (LLM detects questionable health claims)
  # 
  # @example Intelligent customer support routing
  #   ticket = SupportTicket.new(
  #     subject: "My order never arrived",
  #     message: "I'm really frustrated, this is the third time this happened",
  #     customer_tier: "vip",
  #     previous_issues: 2
  #   )
  #   ticket.vibe_if("this customer seems genuinely upset and needs immediate attention") do
  #     ticket.assign_to_senior_agent!
  #   end
  #   # => true (LLM detects frustration and escalation patterns)
  def vibe_if(condition_description, &block)
    evaluator = VibeIf::Evaluator.new(self)
    
    if evaluator.evaluate(condition_description)
      yield if block_given?
      true
    else
      false
    end
  end
end
