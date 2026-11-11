require "spec_helper"

RSpec.describe PrettyIRB::AIHelper do
  describe ".explain_method" do
    it "explains map method" do
      result = PrettyIRB::AIHelper.explain_method("map")
      expect(result).to include("map method")
      expect(result).to include("Transforms each element")
    end

    it "explains select method" do
      result = PrettyIRB::AIHelper.explain_method("select")
      expect(result).to include("select method")
      expect(result).to include("Filters array")
    end

    it "suggests available methods for unknown method" do
      result = PrettyIRB::AIHelper.explain_method("unknown_method")
      expect(result).to include("Available method explanations")
    end
  end

  describe ".get_example" do
    it "provides loop examples" do
      result = PrettyIRB::AIHelper.get_example("loop")
      expect(result).to include("Loops and Iteration Examples")
    end

    it "provides class examples" do
      result = PrettyIRB::AIHelper.get_example("class")
      expect(result).to include("Class Definition Example")
    end

    it "suggests examples for unknown topic" do
      result = PrettyIRB::AIHelper.get_example("unknown")
      expect(result).to include("Available code examples")
    end
  end

  describe ".debug_code" do
    it "analyzes code snippet" do
      result = PrettyIRB::AIHelper.debug_code("[1, 2, 3].first")
      expect(result).to include("Code Analysis")
      expect(result).to include("Complexity:")
    end
  end

  describe ".best_practices" do
    it "provides naming best practices" do
      result = PrettyIRB::AIHelper.best_practices("naming")
      expect(result).to include("Naming Conventions")
    end

    it "provides general best practices as fallback" do
      result = PrettyIRB::AIHelper.best_practices("unknown")
      expect(result).to include("General Ruby Best Practices")
    end
  end

  describe ".quick_reference" do
    it "provides operators reference" do
      result = PrettyIRB::AIHelper.quick_reference("operators")
      expect(result).to include("Ruby Operators Reference")
    end

    it "suggests available references for unknown keyword" do
      result = PrettyIRB::AIHelper.quick_reference("unknown")
      expect(result).to include("Available references:")
    end
  end
end
