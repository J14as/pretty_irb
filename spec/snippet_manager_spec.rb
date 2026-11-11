require "spec_helper"
require "tmpdir"

RSpec.describe PrettyIRB::SnippetManager do
  let(:tmp_dir) { Dir.mktmpdir }
  let(:manager) do
    stub_const("PrettyIRB::SnippetManager::SNIPPET_DIR", tmp_dir)
    described_class.new
  end

  after do
    FileUtils.remove_entry(tmp_dir) if Dir.exist?(tmp_dir)
  end

  describe "#save and #load" do
    it "saves and loads a valid snippet" do
      result = manager.save("my_code", "[1, 2, 3].map(&:to_s)", "convert array of ints to strings")
      expect(result).to eq("✓ Snippet 'my_code' saved")

      loaded = manager.load("my_code")
      expect(loaded).to eq("[1, 2, 3].map(&:to_s)")
    end

    it "rejects invalid snippet names" do
      result = manager.save("invalid name with spaces!", "code")
      expect(result).to include("❌ Invalid snippet name")
    end

    it "returns error when loading nonexistent snippet" do
      result = manager.load("missing_snippet")
      expect(result).to include("❌ Snippet 'missing_snippet' not found")
    end
  end

  describe "#list" do
    it "lists all saved snippets" do
      manager.save("first", "1 + 1", "first snippet")
      manager.save("second", "2 + 2", "second snippet")

      list = manager.list
      expect(list).to include("first: first snippet")
      expect(list).to include("second: second snippet")
    end

    it "returns message when no snippets exist" do
      expect(manager.list).to eq("📋 No snippets saved yet")
    end
  end

  describe "#search" do
    it "finds snippets by keyword, code, or tags" do
      manager.save("array_helper", "[1, 2, 3].each { |x| puts x }", "iterate over elements")
      manager.save("calc", "10 * 5", "multiplication")

      results = manager.search("iterate")
      expect(results).to include("Found 1 snippet(s)")
      expect(results).to include("array_helper")
      expect(results).not_to include("calc")
    end

    it "returns 'No matches found' when search has no hits" do
      manager.save("test", "puts 1")
      expect(manager.search("nonexistent")).to include("No matches found")
    end
  end

  describe "#show" do
    it "shows detailed snippet information" do
      manager.save("demo", "def greet; puts 'hi'; end", "greeting method")
      details = manager.show("demo")
      expect(details).to include("📌 demo")
      expect(details).to include("Description: greeting method")
      expect(details).to include("def greet; puts 'hi'; end")
      expect(details).to include("Tags: method")
    end
  end

  describe "#delete" do
    it "deletes a saved snippet" do
      manager.save("to_delete", "123")
      expect(manager.delete("to_delete")).to eq("✓ Snippet 'to_delete' deleted")
      expect(manager.load("to_delete")).to include("not found")
    end

    it "returns error when deleting non-existent snippet" do
      expect(manager.delete("unknown")).to include("not found")
    end
  end
end
