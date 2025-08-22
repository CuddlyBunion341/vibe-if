require_relative "lib/vibe_if/version"

Gem::Specification.new do |spec|
  spec.name        = "vibe-if"
  spec.version     = VibeIf::VERSION
  spec.authors     = ["Your Name"]
  spec.email       = ["your.email@example.com"]

  spec.summary     = "GPT-powered conditional execution based on variable values"
  spec.description = "A Ruby gem that uses OpenAI to evaluate instance variables and local variables, returning true/false to conditionally execute code blocks"
  spec.homepage    = "https://github.com/yourusername/vibe-if"
  spec.license     = "MIT"

  spec.metadata["homepage_uri"] = spec.homepage
  spec.metadata["source_code_uri"] = "https://github.com/yourusername/vibe-if"

  spec.files = Dir.chdir(File.expand_path(__dir__)) do
    Dir["{lib}/**/*", "README.md", "LICENSE"]
  end

  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{\Aexe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.required_ruby_version = ">= 2.7.0"

  spec.add_dependency "openai", "~> 6.0"
  spec.add_dependency "json", "~> 2.0"

  spec.add_development_dependency "rspec", "~> 3.12"
  spec.add_development_dependency "rake", "~> 13.0"
end