module PrettyIRB
  # Global and per-session configuration options for PrettyIRB.
  class Configuration
    attr_accessor :colorize, :syntax_highlight, :auto_correct, :banner, :rails_env_prompt

    def initialize
      @colorize         = true
      @syntax_highlight = true
      @auto_correct     = true
      @banner           = true
      @rails_env_prompt = true
    end

    # Return a duplicate configuration with any non-nil overrides applied.
    def merge(overrides = {})
      copy = dup
      return copy if overrides.nil?

      hash = overrides.respond_to?(:to_h) ? overrides.to_h : {}
      hash.each do |key, value|
        next if value.nil?

        setter = "#{key}="
        copy.public_send(setter, value) if copy.respond_to?(setter)
      end
      copy
    end

    def to_h
      {
        colorize: @colorize,
        syntax_highlight: @syntax_highlight,
        auto_correct: @auto_correct,
        banner: @banner,
        rails_env_prompt: @rails_env_prompt
      }
    end
  end
end

