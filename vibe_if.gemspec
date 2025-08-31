require_relative "lib/vibe_if/version"

Gem::Specification.new do |spec|
  spec.name    = "vibe_if"
  spec.version = VibeIf::VERSION
  spec.author  = "CuddlyBunion341"
  spec.email   = ["daniel.bengl@renuo.ch"]

  spec.summary     = "GPT-powered conditional execution based on variable values"
  spec.description = "A Ruby gem that uses OpenAI to evaluate instance variables and local variables, returning true/false to conditionally execute code blocks. Inspired by vibesort (https://github.com/abyesilyurt/vibesort)."
  spec.homepage    = "https://github.com/CuddlyBunion341/vibe_if"
  spec.license     = "MIT"

  spec.metadata = {
    "source_code_uri" => spec.homepage,
  }

  spec.files = Dir["lib/**/*.rb", "README.md", "LICENSE"]

  spec.required_ruby_version = ">= 2.7.0"

  spec.add_dependency "openai", "~> 0.19"
end
