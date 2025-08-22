require_relative "vibe_if/version"
require_relative "vibe_if/configuration"
require_relative "vibe_if/evaluator"

module VibeIf
  class << self
    attr_accessor :configuration
  end

  def self.configuration
    @configuration ||= Configuration.new
  end

  def self.configure
    yield(configuration)
  end
end

# Add the vibe_if method to Object so it's available everywhere
class Object
  def vibe_if(condition_description, &block)
    evaluator = VibeIf::Evaluator.new(self)
    
    if evaluator.evaluate(condition_description)
      block.call if block_given?
      true
    else
      false
    end
  end
end