require "irb"

module PrettyIRB
  class Shell
    BANNER = <<~BANNER
      ╭─────────────────────────────────────────────────────────────╮
      │   pretty_irb  v#{PrettyIRB::VERSION}  ·  Enhanced Interactive Ruby Shell   │
      │   type  commands  to list extras  ·  exit / Ctrl+D to quit  │
      ╰─────────────────────────────────────────────────────────────╯
    BANNER

    module OutputHook
      def output_value(omit = false)
        return super unless PrettyIRB::Shell.active?
        return if omit

        puts PrettyIRB::Formatter.format_result(@context.last_value)
      end
    end

    module ExceptionHook
      def handle_exception(exc)
        return super unless PrettyIRB::Shell.active?

        first_line = exc.message.to_s.lines.first&.strip
        PrettyIRB::Shell.history_manager&.record_error("#{exc.class}: #{first_line}")
        super
        PrettyIRB::Shell.print_exception_hint(exc)
      end
    end

    module EvalHook
      def evaluate(code, line_no, *args, **kwargs, &block)
        raw = nil
        if PrettyIRB::Shell.active?
          raw = PrettyIRB::Shell.extract_raw_code(code)
          if raw && PrettyIRB.configuration.auto_correct
            corrected = PrettyIRB::AutoCorrector.auto_correct_code(raw)
            if corrected.strip != raw.strip
              label = PrettyIRB::UI.paint("  ↳ auto-corrected: ", :light_black)
              fixed = PrettyIRB::UI.paint(corrected.strip, :yellow)
              warn "#{label}#{fixed}"
            end
          end
        end

        result = begin
          if kwargs.empty?
            super(code, line_no, *args, &block)
          else
            super(code, line_no, *args, **kwargs, &block)
          end
        rescue ArgumentError
          super(code, line_no)
        end

        if PrettyIRB::Shell.active? && raw && !raw.strip.empty?
          preview = begin
            str = result.inspect
            str.length > 80 ? "#{str[0, 77]}..." : str
          rescue
            nil
          end
          PrettyIRB::Shell.history_manager&.add(raw.strip, preview)
        end

        result
      end
    end

    module RailsIRBInitHook
      def initialize(*args, **kwargs, &block)
        if (shell = PrettyIRB::Shell.consume_pending_rails_shell)
          shell.apply_irb_configuration!
        end

        if kwargs.empty?
          super(*args, &block)
        else
          super(*args, **kwargs, &block)
        end
      end
    end

    class << self
      attr_accessor :history_manager, :snippet_manager, :active, :pending_rails_shell

      def active?
        !!@active
      end

      def consume_pending_rails_shell
        shell = @pending_rails_shell
        @pending_rails_shell = nil
        shell
      end

      def extract_raw_code(code)
        if code.is_a?(String)
          code
        elsif code.respond_to?(:code)
          code.code.to_s
        end
      end

      def print_exception_hint(exc)
        return unless PrettyIRB.configuration.auto_correct

        suggestion = PrettyIRB::AutoCorrector.suggest_corrections(exc).to_s.strip
        return if suggestion.empty?
        if exc.message.to_s.include?("Did you mean?") &&
           !suggestion.include?("Receiver is nil") &&
           !suggestion.include?("Did you mean `.")
          return
        end

        puts "  #{PrettyIRB::UI.paint(suggestion, :yellow)}"
      rescue
        nil
      end
    end

    def initialize(config = {})
      @config = config || {}
    end

    def run
      STDOUT.sync = true
      resolved_config = resolve_configuration
      prev_config = PrettyIRB.configuration
      PrettyIRB.instance_variable_set(:@configuration, resolved_config)
      self.class.active = true

      puts render_banner if resolved_config.banner

      self.class.history_manager = HistoryManager.new
      self.class.snippet_manager = SnippetManager.new

      # Step 1: patch IRB classes idempotently before anything else
      install_output_hook
      install_eval_hook
      install_exception_hook

      @using_rails_irb_console = rails_irb_console_available?
      if @using_rails_irb_console
        run_with_rails_irb_console
      else
        run_standalone_or_legacy_rails
      end
    ensure
      @using_rails_irb_console = false
      self.class.consume_pending_rails_shell
      self.class.active = false
      PrettyIRB.instance_variable_set(:@configuration, prev_config)
    end

    # Applies PrettyIRB's Reline tuning, prompt, and IRB_RC hook onto the
    # current IRB.conf after IRB.setup has initialized it.
    def apply_irb_configuration!
      tune_input_mode
      configure_prompt
      install_irb_rc_hook
    end

    private

    def resolve_configuration
      PrettyIRB.configuration.merge(@config)
    end

    def rails_app
      return @config[:app] if @config.is_a?(Hash) && @config[:app]
      return Rails.application if defined?(Rails) && Rails.respond_to?(:application)

      nil
    end

    def rails_irb_console_available?
      return false unless rails_app
      return true if defined?(Rails::Console::IRBConsole)

      require "rails/commands/console/irb_console"
      !!defined?(Rails::Console::IRBConsole)
    rescue LoadError
      false
    end

    # Rails 7.2+ / 8.x delegates IRB initialization, helper registration
    # (`reload!`, `app`, `helper`, `controller`), and backtrace cleaning to
    # Rails::Console::IRBConsole. Hook into IRB::Irb#initialize so PrettyIRB
    # layers on top right after IRB.setup(nil) completes.
    def run_with_rails_irb_console
      install_rails_irb_hook
      self.class.pending_rails_shell = self
      build_rails_irb_console(rails_app).start
    end

    def build_rails_irb_console(app)
      init_arity = Rails::Console::IRBConsole.instance_method(:initialize).arity
      if init_arity == 1
        Rails::Console::IRBConsole.new(app)
      else
        Rails::Console::IRBConsole.new(app, @config[:rails_options] || {})
      end
    end

    # Standalone Ruby or Rails 7.0 / 7.1 (before Rails::Console::IRBConsole).
    def run_standalone_or_legacy_rails
      app = rails_app
      load_legacy_rails_console_helpers if app

      # IRB.setup populates IRB.conf (and resets IRB_RC to nil).
      IRB.setup(nil)

      configure_legacy_rails_irb(app) if app
      apply_irb_configuration!

      irb = IRB::Irb.new
      IRB.conf[:MAIN_CONTEXT] = irb.context
      irb.run(IRB.conf)
    end

    def load_legacy_rails_console_helpers
      require "rails/console/app"
      require "rails/console/helpers"
    rescue LoadError
      nil
    end

    def configure_legacy_rails_irb(app)
      IRB.conf[:IRB_NAME] = rails_app_name(app)
      if !rails_local_env? && !ENV.key?("IRB_USE_AUTOCOMPLETE")
        IRB.conf[:USE_AUTOCOMPLETE] = false
      end

      if defined?(Rails) && Rails.respond_to?(:backtrace_cleaner) && Rails.backtrace_cleaner
        prev_filter = IRB.conf[:BACKTRACE_FILTER]
        IRB.conf[:BACKTRACE_FILTER] = lambda do |backtrace|
          backtrace = prev_filter.call(backtrace) if prev_filter.respond_to?(:call)
          Rails.backtrace_cleaner.filter(backtrace)
        end
      end

      if defined?(IRB::ExtendCommandBundle) && defined?(Rails::ConsoleMethods)
        IRB::ExtendCommandBundle.include(Rails::ConsoleMethods)
      end
    end

    def rails_app_name(app)
      if app.respond_to?(:name) && app.name
        app.name.to_s
      elsif app.class.respond_to?(:module_parent_name) && app.class.module_parent_name
        app.class.module_parent_name.downcase
      else
        "rails"
      end
    end

    def rails_local_env?
      return true unless defined?(Rails) && Rails.respond_to?(:env) && Rails.env

      if Rails.env.respond_to?(:local?)
        Rails.env.local?
      else
        Rails.env.development? || Rails.env.test?
      end
    end

    # ── Terminal / input detection ────────────────────────────────────────────
    # On Windows, Reline uses a Win32 API console handler.  In "legacy
    # console" mode (old conhost.exe — PowerShell or cmd.exe without
    # Windows Terminal) Alt+key sequences are read in a way that blocks the
    # input loop, freezing the entire REPL.

    def tune_input_mode
      return unless Gem.win_platform?

      legacy = begin
        Reline::IOGate.instance_variable_get(:@legacy_console)
      rescue
        false
      end

      if legacy
        IRB.conf[:USE_MULTILINE]    = false   # avoid Reline Windows hang
        IRB.conf[:USE_AUTOCOMPLETE] = false
        msg = "  ℹ Legacy Windows console detected — running in single-line mode.\n" \
              "    Open Windows Terminal for full multiline & autocomplete support."
        puts style_text(msg, :light_black)
      end
    rescue
      nil
    end

    # ── Banner & Prompt ───────────────────────────────────────────────────────

    def render_banner
      title = "#{style_text('pretty_irb', :white, :bold)} #{style_text("v#{PrettyIRB::VERSION}", :cyan)}"
      lines = [
        "#{style_text('Enhanced Interactive Ruby Shell', :white)} #{style_text("· Ruby #{RUBY_VERSION}", :light_black)}"
      ]

      if (rails_line = build_rails_banner_line)
        lines << rails_line
      end

      lines << :divider
      lines << [
        "#{style_text('commands', :cyan)} #{style_text('extras', :light_black)}",
        "#{style_text('vars', :cyan)} #{style_text('scope', :light_black)}",
        "#{style_text('bench', :cyan)} #{style_text('profile', :light_black)}",
        "#{style_text('help', :cyan)} #{style_text('IRB', :light_black)}",
        "#{style_text('Ctrl+D', :white)} #{style_text('exit', :light_black)}"
      ].join(style_text("  ·  ", :light_black))

      PrettyIRB::UI.box(lines, title: title, min_width: 66)
    end

    def build_rails_banner_line
      app = rails_app
      return nil unless app

      rails_ver = defined?(Rails) && Rails.respond_to?(:version) ? "Rails #{Rails.version}" : "Rails"
      parts = [style_text("#{rails_app_name(app)} · #{rails_ver}", :light_black)]
      if (badge = rails_env_badge)
        parts << badge
      end
      parts << PrettyIRB::UI.badge("SANDBOX", color: :yellow, bold: true) if rails_sandbox?(app)
      parts.join("  ")
    end

    def rails_sandbox?(app = rails_app)
      app && app.respond_to?(:sandbox?) && app.sandbox?
    end

    def configure_prompt
      prefix       = build_prompt_prefix
      caret_styles = rails_production? ? %i[red bold] : %i[cyan bold]
      IRB.conf[:PROMPT] ||= {}
      IRB.conf[:PROMPT][:PRETTY_IRB] = {
        PROMPT_I: "#{prefix} #{style_text('❯ ', *caret_styles)}",
        PROMPT_N: "#{prefix} #{style_text('│ ', :light_black)}",
        PROMPT_S: "#{prefix} #{style_text('┆ ', :light_black)}",
        PROMPT_C: "#{prefix} #{style_text('· ', :light_black)}",
        RETURN:   "=> %s\n"
      }
      IRB.conf[:PROMPT_MODE]  = :PRETTY_IRB
      IRB.conf[:SAVE_HISTORY] ||= 1000
    end

    def build_prompt_prefix
      base  = style_text("[%03n]", :light_black)
      badge = rails_env_badge
      badge ? "#{base} #{badge}" : base
    end

    def rails_production?
      defined?(Rails) && Rails.respond_to?(:env) && Rails.env.to_s == "production"
    end

    def rails_env_badge
      return nil unless PrettyIRB.configuration.rails_env_prompt
      return nil unless defined?(Rails) && Rails.respond_to?(:env) && Rails.env

      env = Rails.env.to_s
      return nil if env.empty?

      styled_env = case env
                   when "development" then style_text("dev", :cyan)
                   when "test"        then style_text("test", :light_blue)
                   when "production"  then style_text("PROD", :red, :bold)
                   else                    style_text(env, :yellow)
                   end

      if rails_sandbox?
        "(#{styled_env}#{style_text(':', :light_black)}#{style_text('sandbox', :yellow)})"
      else
        "(#{styled_env})"
      end
    end

    def install_irb_rc_hook
      prev_rc = IRB.conf[:IRB_RC]
      IRB.conf[:IRB_RC] = proc do |ctx|
        prev_rc.call(ctx) if prev_rc.respond_to?(:call)
        ctx.prompt_mode      = :PRETTY_IRB
        ctx.auto_indent_mode = true
        ctx.workspace.main.extend(PrettyIRB::IRBCommands)
        if !@using_rails_irb_console && defined?(Rails::ConsoleMethods)
          ctx.workspace.main.extend(Rails::ConsoleMethods)
        end
        IRB.conf[:MAIN_CONTEXT] ||= ctx
      end
    end

    def style_text(text, *styles)
      PrettyIRB::UI.paint(text, *styles)
    end

    # ── Hooks ─────────────────────────────────────────────────────────────────

    def install_output_hook
      return if IRB::Irb.ancestors.include?(OutputHook)

      IRB::Irb.prepend(OutputHook)
    rescue => e
      warn style_text("  pretty_irb: output hook skipped (#{e.message})", :light_black)
    end

    def install_eval_hook
      return if IRB::Context.ancestors.include?(EvalHook)

      IRB::Context.prepend(EvalHook)
    rescue => e
      warn style_text("  pretty_irb: eval hook skipped (#{e.message})", :light_black)
    end

    def install_exception_hook
      return unless IRB::Irb.instance_methods.include?(:handle_exception)
      return if IRB::Irb.ancestors.include?(ExceptionHook)

      IRB::Irb.prepend(ExceptionHook)
    rescue => e
      warn style_text("  pretty_irb: exception hook skipped (#{e.message})", :light_black)
    end

    def install_rails_irb_hook
      return if IRB::Irb.ancestors.include?(RailsIRBInitHook)

      IRB::Irb.prepend(RailsIRBInitHook)
    rescue => e
      warn style_text("  pretty_irb: rails init hook skipped (#{e.message})", :light_black)
    end
  end
end
