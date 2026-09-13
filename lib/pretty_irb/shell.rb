require "irb"

module PrettyIRB
  class Shell
    BANNER = <<~BANNER
      ╭─────────────────────────────────────────────────────────────╮
      │   pretty_irb  v#{PrettyIRB::VERSION}  ·  Enhanced Interactive Ruby Shell   │
      │   type  commands  to list extras  ·  exit / Ctrl+D to quit  │
      ╰─────────────────────────────────────────────────────────────╯
    BANNER

    class << self
      attr_accessor :history_manager, :snippet_manager
    end

    def initialize(config = {})
      @config = config
    end

    def run
      STDOUT.sync = true
      puts BANNER.cyan

      Shell.history_manager = HistoryManager.new
      Shell.snippet_manager = SnippetManager.new

      # Step 1: patch IRB classes before anything else
      install_output_hook
      install_eval_hook

      # Step 2: IRB.setup populates IRB.conf (and resets IRB_RC to nil).
      #         Must happen before we configure anything.
      IRB.setup(nil)

      # Step 3: detect the terminal environment and tune input mode.
      #         Must happen AFTER setup (so USE_MULTILINE can be overridden)
      #         but BEFORE IRB::Irb.new reads those values.
      tune_input_mode

      # Step 4: prompt — IRB.conf[:PROMPT] now exists.
      configure_prompt

      # Step 5: IRB_RC — fires inside irb.run, after IRB::Irb.new but before
      #          the first prompt.  Safe place for ctx-level settings.
      prev_rc = IRB.conf[:IRB_RC]
      IRB.conf[:IRB_RC] = proc do |ctx|
        prev_rc.call(ctx) if prev_rc.respond_to?(:call)
        ctx.prompt_mode      = :PRETTY_IRB
        ctx.auto_indent_mode = true
        ctx.workspace.main.extend(PrettyIRB::IRBCommands)
      end

      # Step 6: start the REPL directly to avoid a second IRB.setup call.
      irb = IRB::Irb.new
      IRB.conf[:MAIN_CONTEXT] = irb.context
      irb.run(IRB.conf)
    end

    private

    # ── Terminal / input detection ────────────────────────────────────────────
    # On Windows, Reline uses a Win32 API console handler.  In "legacy
    # console" mode (old conhost.exe — PowerShell or cmd.exe without
    # Windows Terminal) Alt+key sequences are read in a way that blocks the
    # input loop, freezing the entire REPL.
    #
    # We detect this and switch to single-line (non-Reline) input, which
    # avoids the freeze while keeping colour, our custom prompt, and all
    # pretty_irb commands.  Full features (auto-indent, │ continuation, tab
    # completion) work when the user opens the same shell inside Windows
    # Terminal.

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
        puts (
          "  legacy console detected — Alt+key sequences freeze Reline.\n" \
          "  Running in single-line mode.  Open  Windows Terminal  for\n" \
          "  full auto-indent and tab-complete support."
        ).light_black
      end
    rescue
      nil
    end

    # ── Prompt ────────────────────────────────────────────────────────────────

    def configure_prompt
      IRB.conf[:PROMPT][:PRETTY_IRB] = {
        PROMPT_I: "[%03n]".light_black + "❯ ".cyan,
        PROMPT_N: "[%03n]".light_black + "│ ".light_cyan,
        PROMPT_S: "[%03n]".light_black + "│ ".light_cyan,
        PROMPT_C: "[%03n]".light_black + "│ ".light_cyan,
        RETURN:   "=> %s\n"
      }
      IRB.conf[:PROMPT_MODE]  = :PRETTY_IRB
      IRB.conf[:SAVE_HISTORY] = 1000
    end

    # ── Output hook ───────────────────────────────────────────────────────────

    def install_output_hook
      IRB::Irb.prepend(Module.new do
        def output_value(omit = false)
          puts PrettyIRB::Formatter.format_result(@context.last_value)
        end
      end)
    rescue => e
      warn "  pretty_irb: output hook skipped (#{e.message})".light_black
    end

    # ── Eval hook ─────────────────────────────────────────────────────────────
    # IRB >= 1.4 passes IRB::Statement objects, not plain Strings.
    # Extract the raw code string for our features; always forward the
    # original object unchanged so IRB's own command dispatch still works.

    def install_eval_hook
      IRB::Context.prepend(Module.new do
        def evaluate(code, line_no, *args, **kwargs, &block)
          raw = code.is_a?(String) ? code
              : code.respond_to?(:code) ? code.code.to_s
              : nil

          if raw
            corrected = PrettyIRB::AutoCorrector.auto_correct_code(raw)
            if corrected.strip != raw.strip
              warn "  ↻  auto-corrected: #{corrected.strip}".yellow
            end
          end

          result = begin
            super(code, line_no, *args, **kwargs, &block)
          rescue ArgumentError
            super(code, line_no)
          end

          PrettyIRB::Shell.history_manager&.add(raw.strip) if raw && !raw.strip.empty?
          result
        end
      end)
    rescue => e
      warn "  pretty_irb: eval hook skipped (#{e.message})".light_black
    end
  end
end
