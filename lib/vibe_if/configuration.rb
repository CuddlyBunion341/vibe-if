module VibeIf
  # Configuration class for VibeIf settings.
  # Manages OpenAI API credentials and model parameters.
  class Configuration
    # @!attribute [rw] openai_api_key
    #   @return [String, nil] the OpenAI API key for authentication
    # @!attribute [rw] model
    #   @return [String] the OpenAI model to use for evaluation (default: "gpt-3.5-turbo")
    # @!attribute [rw] max_tokens
    #   @return [Integer] maximum tokens for the AI response (default: 10)
    # @!attribute [rw] temperature
    #   @return [Float] temperature setting for AI responses, lower values are more deterministic (default: 0.1)
    attr_accessor :openai_api_key, :model, :max_tokens, :temperature

    # Initializes a new Configuration with default values.
    def initialize
      @openai_api_key = nil
      @model = "gpt-3.5-turbo"
      @max_tokens = 50
      @temperature = 0.1
    end
  end
end
