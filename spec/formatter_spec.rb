require "spec_helper"

RSpec.describe PrettyIRB::Formatter do
  describe ".format_output" do
    it "formats strings in blue" do
      result = PrettyIRB::Formatter.format_output("hello")
      expect(result).to include("\e[0;94;49m") # light_blue ANSI code
    end

    it "formats numbers in green" do
      result = PrettyIRB::Formatter.format_output(42)
      expect(result).to include("\e[0;92;49m") # light_green ANSI code
    end

    it "formats nil in black" do
      result = PrettyIRB::Formatter.format_output(nil)
      expect(result).to include("nil")
    end

    it "formats arrays with colors" do
      result = PrettyIRB::Formatter.format_output([1, 2, 3])
      expect(result).to include("[")
      expect(result).to include("]")
    end

    it "formats hashes with colors" do
      result = PrettyIRB::Formatter.format_output({ a: 1, b: 2 })
      expect(result).to include("{")
      expect(result).to include("}")
    end
  end

  describe ".format_error" do
    it "formats error messages in red" do
      result = PrettyIRB::Formatter.format_error("Something went wrong")
      expect(result).to include("\e[1;31;49m") # red.bold ANSI code
    end
  end
end
