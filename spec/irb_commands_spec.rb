require "spec_helper"

RSpec.describe PrettyIRB::IRBCommands do
  let(:host_class) do
    Class.new do
      include PrettyIRB::IRBCommands
    end
  end

  let(:host) { host_class.new }

  before do
    PrettyIRB::Shell.snippet_manager = PrettyIRB::SnippetManager.new
    PrettyIRB::Shell.history_manager = PrettyIRB::HistoryManager.new
  end

  describe "#commands" do
    it "prints available commands banner and list" do
      expect { host.commands }.to output(/pretty_irb/i).to_stdout
    end
  end

  describe "#cheat" do
    it "outputs cheat sheet" do
      expect { host.cheat("array") }.to output(/Array Cheat Sheet/).to_stdout
    end
  end

  describe "#explain" do
    it "outputs method explanation" do
      expect { host.explain("map") }.to output(/map method/).to_stdout
    end
  end

  describe "#example" do
    it "outputs examples" do
      expect { host.example("loop") }.to output(/Loops and Iteration/).to_stdout
    end
  end

  describe "#practices" do
    it "outputs best practices" do
      expect { host.practices("naming") }.to output(/Naming Conventions/).to_stdout
    end
  end

  describe "#ref" do
    it "outputs quick reference" do
      expect { host.ref("operators") }.to output(/Operators Reference/).to_stdout
    end
  end

  describe "#snippet" do
    it "outputs snippet list by default" do
      expect { host.snippet(:list) }.to output(/No snippets|Saved Snippets/).to_stdout
    end
  end
end
