require "irb"
require "rouge"
require "colorize"
require "did_you_mean"
require "reline"

require_relative "pretty_irb/version"
require_relative "pretty_irb/formatter"
require_relative "pretty_irb/auto_corrector"
require_relative "pretty_irb/ai_helper"
require_relative "pretty_irb/history_manager"
require_relative "pretty_irb/snippet_manager"
require_relative "pretty_irb/variable_inspector"
require_relative "pretty_irb/benchmarker"
require_relative "pretty_irb/cheat_sheet"
require_relative "pretty_irb/shell"

module PrettyIRB
  class Error < StandardError; end

  class << self
    def start(config = {})
      Shell.new(config).run
    end
  end
end
