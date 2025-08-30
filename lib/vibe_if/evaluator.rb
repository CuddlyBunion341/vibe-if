require 'openai'
require 'json'

module VibeIf
  class Evaluator
    def initialize(context_object)
      @context_object = context_object
      @config = VibeIf.configuration
      validate_configuration
    end

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
      variables_text = variables.map { |k, v| "#{k}: #{v.inspect}" }.join(", ")
      
      <<~PROMPT
        Given these variables: #{variables_text}
        
        Evaluate this condition: "#{condition_description}"
        
        Respond with exactly "true" or "false" (lowercase, no quotes, no explanation).
      PROMPT
    end

    def parse_response(response)
      result = response.choices.first.message.content&.strip&.downcase
      result == "true"
    end
  end
end
