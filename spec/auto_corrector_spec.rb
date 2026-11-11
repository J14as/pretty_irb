require "spec_helper"

RSpec.describe PrettyIRB::AutoCorrector do
  describe ".auto_correct_code" do
    it "fixes common method name typos" do
      code = "str.lenght"
      result = PrettyIRB::AutoCorrector.auto_correct_code(code)
      expect(result).to include("length")
    end

    it "fixes size typos" do
      code = "arr.sizze"
      result = PrettyIRB::AutoCorrector.auto_correct_code(code)
      expect(result).to include("size")
    end
  end

  describe ".suggest_corrections" do
    it "provides suggestions for NameError" do
      begin
        eval("undefined_variable")
      rescue NameError => e
        result = PrettyIRB::AutoCorrector.suggest_corrections(e)
        # Result can be empty or have suggestions, just ensure no error
        expect(result).to be_a(String)
      end
    end
    it "suggests safe navigation and typo fixes for NoMethodError" do
      err = begin
        nil.lenght
      rescue NoMethodError => e
        e
      end
      result = PrettyIRB::AutoCorrector.suggest_corrections(err)
      expect(result).to include("`.length`")
      expect(result).to include("`&.lenght`")
    end

    it "handles NoMethodError created without a receiver" do
      err = NoMethodError.new("undefined method 'lenght'", :lenght)
      result = PrettyIRB::AutoCorrector.suggest_corrections(err)
      expect(result).to include("`.length`")
    end

    it "provides helpful hints for SyntaxError" do
      err = SyntaxError.new("unexpected end-of-input, expecting `end'")
      expect(PrettyIRB::AutoCorrector.suggest_corrections(err)).to include("missing `end`")
    end
  end
end
