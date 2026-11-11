require "spec_helper"
require "tmpdir"

RSpec.describe PrettyIRB::HistoryManager do
  let(:history) { described_class.new }

  describe "#add and #all" do
    it "adds entries and displays them" do
      history.add("x = 10", 10)
      history.add("y = 20", 20)
      
      output = history.all
      expect(output).to include("1: x = 10")
      expect(output).to include("=> 10")
      expect(output).to include("2: y = 20")
      expect(output).to include("=> 20")
    end

    it "formats error entries properly" do
      history.add("invalid_code", nil, "NameError: undefined local variable")
      output = history.all
      expect(output).to include("1: invalid_code")
      expect(output).to include("✗ NameError: undefined local variable")
    end

    it "attaches an error to the most recent entry via #record_error" do
      history.add("foo.bar")
      history.record_error("NoMethodError: undefined method `bar'")
      expect(history.all).to include("✗ NoMethodError: undefined method `bar'")
    end

    it "returns 'No history' when empty" do
      expect(history.all).to include("No history")
    end
  end

  describe "#search" do
    it "finds entries matching a keyword" do
      history.add("user.name", "Alice")
      history.add("user.age", 30)
      history.add("other = 1", 1)

      result = history.search("user")
      expect(result).to include("Found 2 matches")
      expect(result).to include("user.name")
      expect(result).to include("user.age")
      expect(result).not_to include("other = 1")
    end

    it "returns 'No matches found' when search has no hits" do
      history.add("x = 1", 1)
      expect(history.search("nonexistent")).to include("No matches found")
    end
  end

  describe "#last" do
    it "returns the last N entries" do
      5.times { |i| history.add("num_#{i} = #{i}", i) }
      result = history.last(2)
      expect(result).to include("num_3")
      expect(result).to include("num_4")
      expect(result).not_to include("num_0")
    end
  end

  describe "#get" do
    it "returns a single entry by line number" do
      history.add("a = 1", 1)
      history.add("b = 2", 2)
      expect(history.get(2)).to eq("2: b = 2\n=> 2")
    end

    it "returns empty string for nonexistent line" do
      expect(history.get(999)).to eq("")
    end
  end

  describe "#clear" do
    it "clears all history entries" do
      history.add("test", true)
      expect(history.clear).to eq("✓ History cleared")
      expect(history.entries).to be_empty
    end
  end

  describe "#export" do
    it "exports history to a valid file" do
      history.add("puts 'hello'", nil)
      Dir.mktmpdir do |dir|
        export_path = File.join(dir, "test_history.rb")
        result = history.export(export_path)
        expect(result).to include("✓ History exported to")
        expect(File.read(export_path)).to include("puts 'hello'")
      end
    end

    it "refuses to write to system-sensitive locations" do
      sensitive_path = Gem.win_platform? ? "C:/Windows/System32/test.rb" : "/etc/passwd"
      result = history.export(sensitive_path)
      expect(result).to include("❌ Refusing to write to system path")
    end
  end
end
