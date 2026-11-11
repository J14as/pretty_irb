require "spec_helper"

RSpec.describe PrettyIRB::Shell do
  after do
    PrettyIRB::Shell.active = false
    PrettyIRB::Shell.consume_pending_rails_shell
    PrettyIRB.reset_configuration!
  end

  describe "constants" do
    it "defines a BANNER with version" do
      expect(PrettyIRB::Shell::BANNER).to include("pretty_irb")
      expect(PrettyIRB::Shell::BANNER).to include(PrettyIRB::VERSION)
    end
  end

  describe "#initialize" do
    it "accepts a config hash" do
      shell = PrettyIRB::Shell.new({ test: true })
      expect(shell).to be_a(PrettyIRB::Shell)
    end
  end

  describe "class accessors" do
    it "allows setting and getting history and snippet managers" do
      hm = PrettyIRB::HistoryManager.new
      sm = PrettyIRB::SnippetManager.new
      PrettyIRB::Shell.history_manager = hm
      PrettyIRB::Shell.snippet_manager = sm
      expect(PrettyIRB::Shell.history_manager).to eq(hm)
      expect(PrettyIRB::Shell.snippet_manager).to eq(sm)
    end
  end

  describe "#run (standalone)" do
    it "sets up IRB prompt, IRB_RC commands, and cleans up active state" do
      main_obj = Object.new
      workspace = Struct.new(:main).new(main_obj)
      context = Struct.new(:workspace, :prompt_mode, :auto_indent_mode).new(workspace, nil, nil)
      fake_irb = instance_double("IRB::Irb", context: context)

      allow(IRB).to receive(:setup) { IRB.conf[:PROMPT] = {}; IRB.conf[:IRB_RC] = nil }
      allow(IRB::Irb).to receive(:new).and_return(fake_irb)
      expect(fake_irb).to receive(:run) do |conf|
        expect(PrettyIRB::Shell).to be_active
        expect(conf[:PROMPT_MODE]).to eq(:PRETTY_IRB)
        conf[:IRB_RC].call(context)
        expect(context.prompt_mode).to eq(:PRETTY_IRB)
        expect(context.auto_indent_mode).to eq(true)
        expect(main_obj).to be_a(PrettyIRB::IRBCommands)
      end

      expect { PrettyIRB.start(banner: false, colorize: false) }
        .not_to output(/Enhanced Interactive Ruby Shell/).to_stdout
      expect(PrettyIRB::Shell).not_to be_active
      expect(PrettyIRB.configuration.colorize).to eq(true)
    end
  end

  describe "Rails integration" do
    let(:main_obj) { Object.new }
    let(:workspace) { Struct.new(:main).new(main_obj) }
    let(:context) { Struct.new(:workspace, :prompt_mode, :auto_indent_mode).new(workspace, nil, nil) }

    it "layers onto Rails::Console::IRBConsole (Rails 7.2+ / 8.x) and preserves Rails IRB_RC" do
      rails_rc_called = false
      test_ctx = context

      irb_console_class = Class.new do
        define_method(:initialize) { |app| @app = app }
        define_method(:start) do
          IRB.conf[:PROMPT] = {}
          IRB.conf[:IRB_RC] = proc { |_ctx| rails_rc_called = true }
          PrettyIRB::Shell.consume_pending_rails_shell&.apply_irb_configuration!
          IRB.conf[:IRB_RC].call(test_ctx)
        end
      end

      fake_env = Struct.new(:development?, :test?, :to_s).new(true, false, "development")
      fake_app = Struct.new(:name).new("my_rails_app")
      fake_rails = Module.new
      fake_rails.define_singleton_method(:application) { fake_app }
      fake_rails.define_singleton_method(:env) { fake_env }

      stub_const("Rails", fake_rails)
      stub_const("Rails::Console::IRBConsole", irb_console_class)

      PrettyIRB.start(banner: false, colorize: false)

      expect(rails_rc_called).to eq(true)
      expect(IRB.conf[:PROMPT][:PRETTY_IRB][:PROMPT_I]).to include("(dev)")
      expect(IRB.conf[:PROMPT][:PRETTY_IRB][:PROMPT_N]).to include("│")
      expect(main_obj).to be_a(PrettyIRB::IRBCommands)
      expect(PrettyIRB::Shell).not_to be_active
    end

    it "highlights production prompts with PROD and sandbox badges in banner/prompt" do
      fake_env = Struct.new(:development?, :test?, :to_s).new(false, false, "production")
      fake_app = Struct.new(:name, :sandbox?).new("shop_api", true)
      fake_rails = Module.new
      fake_rails.define_singleton_method(:application) { fake_app }
      fake_rails.define_singleton_method(:env) { fake_env }
      fake_rails.define_singleton_method(:version) { "8.0.1" }

      stub_const("Rails", fake_rails)
      PrettyIRB.configure { |c| c.colorize = false }

      shell = PrettyIRB::Shell.new(banner: true, colorize: false)
      shell.apply_irb_configuration!

      expect(IRB.conf[:PROMPT][:PRETTY_IRB][:PROMPT_I]).to include("(PROD:sandbox)")
      banner = shell.send(:render_banner)
      expect(banner).to include("shop_api · Rails 8.0.1")
      expect(banner).to include("[SANDBOX]")
    end

    it "supports Rails 7.0 / 7.1 fallback with Rails::ConsoleMethods and Rails.backtrace_cleaner" do
      console_methods = Module.new do
        def reload!; :reloaded; end
      end

      cleaner = Object.new
      cleaner.define_singleton_method(:filter) { |bt| bt.take(1) }

      fake_env = Struct.new(:development?, :test?, :to_s).new(true, false, "development")
      fake_app = Struct.new(:name).new("legacy_rails_app")
      fake_rails = Module.new
      fake_rails.define_singleton_method(:application) { fake_app }
      fake_rails.define_singleton_method(:env) { fake_env }
      fake_rails.define_singleton_method(:backtrace_cleaner) { cleaner }

      stub_const("Rails", fake_rails)
      stub_const("Rails::ConsoleMethods", console_methods)

      fake_irb = instance_double("IRB::Irb", context: context)
      allow(IRB).to receive(:setup) { IRB.conf.clear; IRB.conf[:PROMPT] = {}; IRB.conf[:IRB_RC] = nil }
      allow(IRB::Irb).to receive(:new).and_return(fake_irb)

      shell = PrettyIRB::Shell.new(banner: false, colorize: false)
      allow(shell).to receive(:rails_irb_console_available?).and_return(false)
      allow(shell).to receive(:load_legacy_rails_console_helpers)

      expect(fake_irb).to receive(:run) do |conf|
        expect(conf[:IRB_NAME]).to eq("legacy_rails_app")
        expect(conf[:BACKTRACE_FILTER].call(%w[a b c])).to eq(%w[a])
        conf[:IRB_RC].call(context)
        expect(main_obj).to be_a(PrettyIRB::IRBCommands)
        expect(main_obj).to be_a(console_methods)
        expect(main_obj.reload!).to eq(:reloaded)
      end

      shell.run
    end

    it "invokes apply_irb_configuration! inside RailsIRBInitHook before superclass initialize" do
      calls = []
      harness = Class.new do
        define_method(:initialize) { calls << :super_init }
        prepend PrettyIRB::Shell::RailsIRBInitHook
      end

      shell = instance_double(PrettyIRB::Shell)
      expect(shell).to receive(:apply_irb_configuration!) { calls << :pretty_irb_config }
      PrettyIRB::Shell.pending_rails_shell = shell

      harness.new
      expect(calls).to eq(%i[pretty_irb_config super_init])
      expect(PrettyIRB::Shell.pending_rails_shell).to be_nil
    end
  end

  describe "hooks" do
    it "routes OutputHook through Formatter only when Shell is active and respects omit" do
      ctx = Struct.new(:last_value).new("hello")
      base = Class.new do
        attr_reader :super_calls
        def initialize(ctx)
          @context = ctx
          @super_calls = []
        end

        def output_value(omit = false)
          @super_calls << omit
        end

        prepend PrettyIRB::Shell::OutputHook
      end

      instance = base.new(ctx)

      PrettyIRB::Shell.active = false
      instance.output_value(false)
      expect(instance.super_calls).to eq([false])

      PrettyIRB::Shell.active = true
      PrettyIRB.configure { |c| c.colorize = false }
      expect { instance.output_value(false) }.to output("=> \"hello\"\n").to_stdout
      expect { instance.output_value(true) }.not_to output.to_stdout
    end

    it "honors configuration.auto_correct in EvalHook" do
      base = Class.new do
        def evaluate(code, _line_no, *)
          code
        end

        prepend PrettyIRB::Shell::EvalHook
      end

      instance = base.new
      PrettyIRB::Shell.active = true
      PrettyIRB::Shell.history_manager = PrettyIRB::HistoryManager.new

      PrettyIRB.configure { |c| c.auto_correct = false }
      expect(PrettyIRB::AutoCorrector).not_to receive(:auto_correct_code)
      expect(instance.evaluate("str.lenght", 1)).to eq("str.lenght")
      expect(PrettyIRB::Shell.history_manager.entries.last[:code]).to eq("str.lenght")
      expect(PrettyIRB::Shell.history_manager.entries.last[:result]).to eq('"str.lenght"')
    end

    it "records errors and prints exception hints via ExceptionHook when active" do
      base = Class.new do
        attr_reader :super_handled

        def handle_exception(exc)
          @super_handled = exc
        end

        prepend PrettyIRB::Shell::ExceptionHook
      end

      instance = base.new
      err = begin
        nil.lenght
      rescue NoMethodError => e
        e
      end

      PrettyIRB::Shell.active = false
      expect { instance.handle_exception(err) }.not_to output.to_stdout
      expect(instance.super_handled).to eq(err)

      PrettyIRB::Shell.active = true
      PrettyIRB::Shell.history_manager = PrettyIRB::HistoryManager.new
      PrettyIRB::Shell.history_manager.add("nil.lenght")
      PrettyIRB.configure { |c| c.colorize = false }

      expect { instance.handle_exception(err) }.to output(/`\.length`.*`&\.lenght`/).to_stdout
      expect(PrettyIRB::Shell.history_manager.entries.last[:error]).to include("NoMethodError:")
    end
  end
end
