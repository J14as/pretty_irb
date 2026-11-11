require_relative "../pretty_irb" unless defined?(PrettyIRB::Shell)

module PrettyIRB
  # Hooks PrettyIRB into Ruby on Rails' `rails console` lifecycle so
  # `bin/rails c` boots PrettyIRB automatically without per-environment config.
  class Railtie < ::Rails::Railtie
    config.pretty_irb = if defined?(ActiveSupport::OrderedOptions)
                          ActiveSupport::OrderedOptions.new
                        else
                          PrettyIRB::Configuration.new
                        end
    config.pretty_irb.colorize         = true
    config.pretty_irb.syntax_highlight = true
    config.pretty_irb.auto_correct     = true
    config.pretty_irb.banner           = true
    config.pretty_irb.rails_env_prompt = true

    console do |app|
      next if ENV["DISABLE_PRETTY_IRB"] == "1"

      if app.config.respond_to?(:pretty_irb)
        PrettyIRB.configure do |c|
          opts = app.config.pretty_irb
          c.colorize         = opts.colorize         unless opts.colorize.nil?
          c.syntax_highlight = opts.syntax_highlight unless opts.syntax_highlight.nil?
          c.auto_correct     = opts.auto_correct     unless opts.auto_correct.nil?
          c.banner           = opts.banner           unless opts.banner.nil?
          c.rails_env_prompt = opts.rails_env_prompt unless opts.rails_env_prompt.nil?
        end
      end

      app.config.console ||= PrettyIRB
    end
  end
end
