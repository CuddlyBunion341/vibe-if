require 'openai'
require 'json'

module VibeIf
  class Evaluator
    def initialize(context_object)
      @context_object = context_object
      @openai_client = OpenAI::Client.new(access_token: VibeIf.configuration.openai_api_key)
    end

    def evaluate(condition_description)
      variables_data = extract_variables
      
      prompt = build_prompt(condition_description, variables_data)
      
      response = @openai_client.chat(
        parameters: {
          model: VibeIf.configuration.model,
          messages: [{ role: "user", content: prompt }],
          max_tokens: VibeIf.configuration.max_tokens,
          temperature: VibeIf.configuration.temperature
        }
      )

      result = response.dig("choices", 0, "message", "content")&.strip&.downcase
      result == "true"
    rescue => e
      raise "VibeIf evaluation failed: #{e.message}"
    end

    private

    def extract_variables
      variables = {}
      
      # Extract instance variables
      @context_object.instance_variables.each do |var|
        var_name = var.to_s.gsub('@', '')
        var_value = @context_object.instance_variable_get(var)
        variables[var_name] = serialize_value(var_value)
      end

      # Extract local variables from the calling context
      # Note: This is limited by Ruby's scope, so we'll focus on instance variables
      # and any explicitly passed context
      
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

    def build_prompt(condition_description, variables_data)
      variables_json = variables_data.map { |k, v| "#{k}: #{v.inspect}" }.join(", ")
      
      <<~PROMPT
        Given these variables: #{variables_json}
        
        Evaluate this condition: "#{condition_description}"
        
        Respond with exactly "true" or "false" (lowercase, no quotes, no explanation).
      PROMPT
    end
  end
end