require "spec_helper"

RSpec.describe PrettyIRB do
  after { PrettyIRB.reset_configuration! }

  it "has a version number" do
    expect(PrettyIRB::VERSION).not_to be nil
  end

  it "has a start method" do
    expect(PrettyIRB).to respond_to(:start)
  end

  it "supports configuration and resetting defaults" do
    PrettyIRB.configure do |config|
      config.colorize = false
      config.syntax_highlight = false
      config.auto_correct = false
    end

    expect(PrettyIRB.configuration.colorize).to eq(false)
    expect(PrettyIRB.configuration.syntax_highlight).to eq(false)
    expect(PrettyIRB.configuration.auto_correct).to eq(false)

    PrettyIRB.reset_configuration!
    expect(PrettyIRB.configuration.colorize).to eq(true)
    expect(PrettyIRB.configuration.syntax_highlight).to eq(true)
    expect(PrettyIRB.configuration.auto_correct).to eq(true)
  end
end
