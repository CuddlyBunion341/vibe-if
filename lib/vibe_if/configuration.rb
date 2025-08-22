module VibeIf
  class Configuration
    attr_accessor :openai_api_key, :model, :max_tokens, :temperature

    def initialize
      @openai_api_key = nil
      @model = "gpt-3.5-turbo"
      @max_tokens = 10
      @temperature = 0.1
    end
  end
end