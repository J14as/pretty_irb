require "spec_helper"

RSpec.describe PrettyIRB::UI do
  after { PrettyIRB.reset_configuration! }

  describe ".visible_length and .pad_right" do
    it "ignores ANSI escape sequences when measuring width and padding" do
      styled = "\e[0;36;49mhello\e[0m"
      expect(described_class.visible_length(styled)).to eq(5)
      padded = described_class.pad_right(styled, 8)
      expect(described_class.visible_length(padded)).to eq(8)
    end
  end

  describe ".paint" do
    it "applies colorize styles when colorize is enabled" do
      expect(described_class.paint("ok", :cyan)).to include("\e[")
    end

    it "returns plain text when colorize is disabled" do
      PrettyIRB.configure { |c| c.colorize = false }
      expect(described_class.paint("ok", :cyan, :bold)).to eq("ok")
    end
  end

  describe ".box" do
    it "renders an aligned rounded box with title and divider" do
      PrettyIRB.configure { |c| c.colorize = false }
      rendered = described_class.box(
        ["Line one", :divider, "Line two"],
        title: "pretty_irb",
        min_width: 30
      )

      lines = rendered.split("\n")
      expect(lines.first).to start_with("╭─ pretty_irb ")
      expect(lines[2]).to start_with("├─")
      expect(lines.last).to start_with("╰─")
      expect(lines.map(&:length).uniq.size).to eq(1)
    end
  end
end

