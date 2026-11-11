require "spec_helper"

RSpec.describe PrettyIRB::VariableInspector do
  def create_sample_binding
    num = 42
    str = "hello world"
    arr = [1, 2, 3]
    hsh = { a: 1, b: 2 }
    binding
  end

  let(:sample_binding) { create_sample_binding }
  let(:inspector) { described_class.new(sample_binding) }

  describe "#list_variables" do
    it "lists all local variables in the binding" do
      result = inspector.list_variables
      expect(result).to include("Local Variables")
      expect(result).to include("num: Integer")
      expect(result).to include("str: String")
      expect(result).to include("arr: Array")
      expect(result).to include("hsh: Hash")
    end

    it "returns notice when no variables are defined" do
      # Use a binding from a clean scope that has no local variables
      empty_b = Module.new { def self.clean_binding; binding; end }.clean_binding
      empty_inspector = described_class.new(empty_b)
      expect(empty_inspector.list_variables).to include("No variables defined yet")
    end
  end

  describe "#inspect_var" do
    it "returns detailed info for a variable" do
      result = inspector.inspect_var("str")
      expect(result).to include("Variable: str")
      expect(result).to include("Type: String")
      expect(result).to include("String Info:")
      expect(result).to include("Length: 11")
    end

    it "returns error for missing variable" do
      expect(inspector.inspect_var("nonexistent")).to include("❌ Variable 'nonexistent' not found")
    end
  end

  describe "#get" do
    it "gets the value of a variable" do
      expect(inspector.get("num")).to eq(42)
    end

    it "returns nil if variable does not exist" do
      expect(inspector.get("nonexistent")).to be_nil
    end
  end

  describe "#by_type" do
    it "filters variables by class type" do
      result = inspector.by_type("String")
      expect(result).to include("Variables of type String")
      expect(result).to include("str: String")
      expect(result).not_to include("num: Integer")
    end

    it "returns message when no variable matches type" do
      result = inspector.by_type("Regexp")
      expect(result).to include("❌ No variables of type Regexp")
    end
  end

  describe "#search" do
    it "finds variables matching a name" do
      result = inspector.search("st")
      expect(result).to include("Found 1 variable(s)")
      expect(result).to include("str: String")
    end

    it "returns message when no variable matches keyword" do
      result = inspector.search("xyz")
      expect(result).to include("No variables matching 'xyz'")
    end
  end

  describe "#memory_usage" do
    it "estimates memory usage for variables" do
      result = inspector.memory_usage
      expect(result).to include("💾 Memory Usage:")
      expect(result).to include("Total: ~")
      expect(result).to include("str:")
    end
  end
end
