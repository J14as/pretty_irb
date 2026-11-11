require "spec_helper"

RSpec.describe "PrettyIRB::Railtie" do
  let(:ordered_options_class) do
    Class.new(Hash) do
      def method_missing(name, *args)
        key = name.to_s
        if key.end_with?("=")
          self[key.chomp("=").to_sym] = args.first
        else
          self[name.to_sym]
        end
      end

      def respond_to_missing?(*)
        true
      end
    end
  end

  let(:fake_railtie_base) do
    opts_klass = ordered_options_class
    Class.new do
      class << self
        attr_accessor :console_blocks

        def config
          @config ||= begin
            cfg = Object.new
            cfg.define_singleton_method(:pretty_irb) { @pretty_irb }
            cfg.define_singleton_method(:pretty_irb=) { |val| @pretty_irb = val }
            cfg
          end
        end

        def console(&block)
          @console_blocks ||= []
          @console_blocks << block if block
          @console_blocks
        end
      end
    end
  end

  let(:railtie_path) { File.expand_path("../../../lib/pretty_irb/railtie.rb", __dir__) }

  before do
    PrettyIRB.reset_configuration!
    stub_const("ActiveSupport::OrderedOptions", ordered_options_class)
    stub_const("Rails::Railtie", fake_railtie_base)
    PrettyIRB.send(:remove_const, :Railtie) if PrettyIRB.const_defined?(:Railtie, false)
    load railtie_path
  end

  after do
    PrettyIRB.send(:remove_const, :Railtie) if PrettyIRB.const_defined?(:Railtie, false)
    PrettyIRB.reset_configuration!
  end

  def build_fake_app(console: nil)
    app_config = Struct.new(:console, :pretty_irb).new(console, PrettyIRB::Railtie.config.pretty_irb.dup)
    Struct.new(:config).new(app_config)
  end

  def run_console_hook(app)
    PrettyIRB::Railtie.console_blocks.each { |blk| blk.call(app) }
  end

  it "defines default pretty_irb configuration options without booting the REPL" do
    expect(PrettyIRB).not_to receive(:start)
    expect(PrettyIRB::Railtie.config.pretty_irb.colorize).to eq(true)
    expect(PrettyIRB::Railtie.config.pretty_irb.syntax_highlight).to eq(true)
    expect(PrettyIRB::Railtie.config.pretty_irb.auto_correct).to eq(true)
    expect(PrettyIRB::Railtie.config.pretty_irb.banner).to eq(true)
    expect(PrettyIRB::Railtie.config.pretty_irb.rails_env_prompt).to eq(true)
  end

  it "registers PrettyIRB as app.config.console when console loads" do
    app = build_fake_app
    run_console_hook(app)

    expect(app.config.console).to eq(PrettyIRB)
  end

  it "propagates app.config.pretty_irb overrides to PrettyIRB.configuration" do
    app = build_fake_app
    app.config.pretty_irb.colorize = false
    app.config.pretty_irb.auto_correct = false
    app.config.pretty_irb.rails_env_prompt = false

    run_console_hook(app)

    expect(PrettyIRB.configuration.colorize).to eq(false)
    expect(PrettyIRB.configuration.auto_correct).to eq(false)
    expect(PrettyIRB.configuration.rails_env_prompt).to eq(false)
  end

  it "preserves an explicitly configured custom console" do
    custom_console = Class.new
    app = build_fake_app(console: custom_console)

    run_console_hook(app)

    expect(app.config.console).to eq(custom_console)
  end

  it "allows opting out with DISABLE_PRETTY_IRB=1" do
    app = build_fake_app
    allow(ENV).to receive(:[]).and_call_original
    allow(ENV).to receive(:[]).with("DISABLE_PRETTY_IRB").and_return("1")

    run_console_hook(app)

    expect(app.config.console).to be_nil
  end
end

