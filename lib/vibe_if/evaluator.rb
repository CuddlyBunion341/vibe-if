require 'openai'
require 'json'

module VibeIf
  # Evaluator handles the AI-powered evaluation of natural language conditions.
  # It extracts context from objects and uses OpenAI to determine condition truthiness.
  class Evaluator
    # Initializes the evaluator with a context object.
    # 
    # @param context_object [Object] the object whose state will be evaluated
    # @raise [RuntimeError] if OpenAI API key is not configured
    def initialize(context_object)
      @context_object = context_object
      @config = VibeIf.configuration
      validate_configuration
    end

    # Evaluates a natural language condition against the context object.
    # 
    # @param condition_description [String] the condition to evaluate in natural language
    # @return [Boolean] true if the condition is met, false otherwise
    # @raise [RuntimeError] if evaluation fails due to API errors or other issues
    # 
    # @example Nuanced writing quality assessment
    #   essay = StudentEssay.new(
    #     text: "Technology has revolutionized our lives. It helps us connect with people. But also creates problems like addiction and privacy issues.",
    #     grade_level: "high_school",
    #     word_count: 1200,
    #     assignment: "argumentative_essay"
    #   )
    #   evaluator = VibeIf::Evaluator.new(essay)
    #   evaluator.evaluate("this essay demonstrates sophisticated critical thinking and analysis")
    #   # => false (LLM detects simplistic reasoning despite meeting word count)
    # 
    # @example Intent detection from ambiguous text
    #   message = CustomerMessage.new(
    #     text: "I guess the product is fine for what it is",
    #     context: "post_purchase_survey",
    #     customer_history: "previous_complaints",
    #     product_category: "premium"
    #   )
    #   evaluator = VibeIf::Evaluator.new(message)
    #   evaluator.evaluate("this customer is expressing subtle dissatisfaction")
    #   # => true (LLM detects lukewarm sentiment and contextual disappointment)
    def evaluate(condition_description)
      variables = extract_variables
      prompt = build_prompt(condition_description, variables)
      
      response = openai_client.chat.completions.create(
        model: @config.model,
        messages: [{ role: "user", content: prompt }],
        max_tokens: @config.max_tokens,
        temperature: @config.temperature
      )

      parse_response(response)
    rescue => e
      raise "VibeIf evaluation failed: #{e.message}"
    end

    private

    def validate_configuration
      return if @config.openai_api_key

      raise "OpenAI API key not configured. Use VibeIf.configure to set it."
    end

    def openai_client
      @openai_client ||= OpenAI::Client.new(api_key: @config.openai_api_key)
    end

    def extract_variables
      variables = {}
      
      @context_object.instance_variables.each do |var|
        name = var.to_s.delete('@')
        value = @context_object.instance_variable_get(var)
        variables[name] = serialize_value(value)
      end
      
      variables
    end

    def serialize_value(value)
      case value
      when String, Numeric, TrueClass, FalseClass, NilClass
        value
      when Array, Hash
        value.inspect
      else
        value.to_s
      end
    end

    def build_prompt(condition_description, variables)
      variables_text = variables.map { |k, v| "#{k}: #{v.inspect}" }.join("\n")
      
      <<~PROMPT
        You are evaluating whether a condition is true based on the given data.

        Object data:
        #{variables_text}

        Condition to evaluate: "#{condition_description}"

        Consider the context and meaning carefully. For content quality, look for evidence-based information, credible sources, and reasonable claims. For sentiment, consider tone and subtext beyond surface words.

        Respond with exactly "true" or "false" (no quotes, no explanation).
      PROMPT
    end

    def parse_response(response)
      result = response.choices.first.message.content&.strip&.downcase
      result == "true"
    end
  end
end
