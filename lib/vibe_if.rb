require "vibe_if/version"
require "vibe_if/configuration"
require "vibe_if/evaluator"

module VibeIf
  class << self
    def configuration
      @configuration ||= Configuration.new
    end

    def configure
      yield(configuration)
    end
  end
end

class Object
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
