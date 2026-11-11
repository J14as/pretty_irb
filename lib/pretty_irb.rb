require "irb"
require "rouge"
require "colorize"
require "did_you_mean"
require "reline"

require_relative "pretty_irb/version"
require_relative "pretty_irb/configuration"
require_relative "pretty_irb/ui"
require_relative "pretty_irb/formatter"
require_relative "pretty_irb/auto_corrector"
require_relative "pretty_irb/ai_helper"
require_relative "pretty_irb/history_manager"
require_relative "pretty_irb/snippet_manager"
require_relative "pretty_irb/variable_inspector"
require_relative "pretty_irb/benchmarker"
require_relative "pretty_irb/cheat_sheet"
require_relative "pretty_irb/irb_commands"
require_relative "pretty_irb/shell"
require_relative "pretty_irb/railtie" if defined?(Rails::Railtie)

module PrettyIRB
  class Error < StandardError; end

  class << self
    def configuration
      @configuration ||= Configuration.new
    end

    def configure
      yield(configuration)
      configuration
    end

    def reset_configuration!
      @configuration = Configuration.new
    end

    def start(config = {})
      Shell.new(config).run
    end
  end
end
