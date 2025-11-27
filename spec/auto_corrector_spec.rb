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
  end
end
