require "spec_helper"

RSpec.describe PrettyIRB::CheatSheet do
  describe ".show" do
    it "returns general cheat sheet when no topic is given" do
      result = PrettyIRB::CheatSheet.show
      expect(result).to include("Ruby General Cheat Sheet")
      expect(result).to include("Variables & Constants:")
      expect(result).to include("Conditionals:")
    end

    it "returns array cheat sheet" do
      result = PrettyIRB::CheatSheet.show("array")
      expect(result).to include("Array Cheat Sheet")
      expect(result).to include("map")
    end

    it "returns hash cheat sheet" do
      result = PrettyIRB::CheatSheet.show("hash")
      expect(result).to include("Hash Cheat Sheet")
      expect(result).to include("keys")
    end

    it "returns string cheat sheet" do
      result = PrettyIRB::CheatSheet.show("string")
      expect(result).to include("String Cheat Sheet")
    end

    it "returns enumerable cheat sheet" do
      result = PrettyIRB::CheatSheet.show("enumerable")
      expect(result).to include("Enumerable Cheat Sheet")
    end

    it "returns file cheat sheet" do
      result = PrettyIRB::CheatSheet.show("file")
      expect(result).to include("File I/O Cheat Sheet")
    end

    it "returns regex cheat sheet" do
      result = PrettyIRB::CheatSheet.show("regex")
      expect(result).to include("Regular Expressions Cheat Sheet")
    end

    it "returns date cheat sheet" do
      result = PrettyIRB::CheatSheet.show("date")
      expect(result).to include("Date & Time Cheat Sheet")
    end

    it "handles unknown topic" do
      result = PrettyIRB::CheatSheet.show("unknown_xyz")
      expect(result).to include("Unknown topic")
    end
  end
end
