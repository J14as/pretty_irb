Gem::Specification.new do |spec|
  spec.name          = "pretty_irb"
  spec.version       = "0.1.3"
  spec.authors       = ["Jayesh"]
  spec.email         = ["jayesh@example.com"]
  spec.summary       = "A pretty IRB replacement with auto-correct and beautiful fonts"
  spec.description   = "An enhanced interactive Ruby shell with pretty formatting, syntax highlighting, and auto-correct functionality"
  spec.homepage      = "https://github.com/j14as/pretty_irb"
  spec.license       = "MIT"

  # Prefer files from git, but fall back to a conservative glob when git isn't available
  git_files = nil
  begin
    git_files = `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  rescue
    git_files = nil
  end

  spec.files = if git_files && !git_files.empty?
                 git_files
               else
                 Dir.chdir(File.expand_path(__dir__)) do
                   Dir["lib/**/*"] + Dir["exe/*"] + Dir["*.md"] + ["LICENSE.txt", "Gemfile", "Rakefile"]
                 end
               end
  spec.bindir        = "exe"
  spec.executables   = ["pretty_irb", "irb1"]
  spec.require_paths = ["lib"]

  spec.required_ruby_version = ">= 2.7.0"

  # Dependencies
  spec.add_dependency "irb", ">= 1.0"
  spec.add_dependency "rouge", "~> 3.26"           # Syntax highlighting
  spec.add_dependency "colorize", "~> 0.8"         # Colored output
  # did_you_mean ships with recent Rubies (e.g. Ruby 3.4 provides did_you_mean 2.x).
  # Allow any version >= 1.5 but < 3.0 to avoid conflicts with older constraints.
  spec.add_dependency "did_you_mean", ">= 1.5", "< 3.0"     # Auto-correct suggestions
  spec.add_dependency "reline", "~> 0.3"           # Enhanced readline
  spec.add_dependency "benchmark"                   # Performance measurement

  # Development dependencies
  spec.add_development_dependency "bundler", "~> 2.0"
  spec.add_development_dependency "rake", "~> 13.0"
  spec.add_development_dependency "rspec", "~> 3.0"
end
