require "fileutils"
require "json"

module PrettyIRB
  class SnippetManager
    SNIPPET_DIR = File.expand_path("~/.pretty_irb_snippets")

    def initialize
      ensure_snippet_dir
    end

    # Save a code snippet
    def save(name, code, description = "")
      return "❌ Invalid snippet name. Use only letters, numbers, underscores, and hyphens." unless valid_name?(name)
      filename = snippet_path(name)
      
      snippet = {
        name: name,
        code: code,
        description: description,
        created_at: Time.now.to_s,
        tags: extract_tags(code)
      }

      File.write(filename, JSON.pretty_generate(snippet))
      "✓ Snippet '#{name}' saved"
    end

    # Load a snippet
    def load(name)
      return "❌ Invalid snippet name." unless valid_name?(name)
      filename = snippet_path(name)
      return "❌ Snippet '#{name}' not found" unless File.exist?(filename)

      snippet = JSON.parse(File.read(filename))
      snippet["code"]
    end

    # List all snippets
    def list
      return "📋 No snippets saved yet" unless Dir.exist?(SNIPPET_DIR)

      snippets = Dir.glob("#{SNIPPET_DIR}/*.json").map do |file|
        data = JSON.parse(File.read(file))
        "  • #{data['name']}: #{data['description']}"
      end

      return "📋 No snippets saved yet" if snippets.empty?

      "📋 Saved Snippets:\n#{snippets.join("\n")}"
    end

    # Search snippets by tag or keyword
    def search(keyword)
      return "📋 No snippets saved yet" unless Dir.exist?(SNIPPET_DIR)

      results = Dir.glob("#{SNIPPET_DIR}/*.json").select do |file|
        data = JSON.parse(File.read(file))
        data["name"].include?(keyword) || 
        data["code"].include?(keyword) ||
        data["tags"].any? { |tag| tag.include?(keyword) }
      end

      return "🔍 No matches found" if results.empty?

      output = "🔍 Found #{results.length} snippet(s):\n\n"
      results.each do |file|
        data = JSON.parse(File.read(file))
        output += "📌 #{data['name']}\n"
        output += "   Description: #{data['description']}\n"
        output += "   Tags: #{data['tags'].join(', ')}\n\n"
      end
      output
    end

    # Delete a snippet
    def delete(name)
      return "❌ Invalid snippet name." unless valid_name?(name)
      filename = snippet_path(name)
      return "❌ Snippet '#{name}' not found" unless File.exist?(filename)

      File.delete(filename)
      "✓ Snippet '#{name}' deleted"
    end

    # Show snippet details
    def show(name)
      return "❌ Invalid snippet name." unless valid_name?(name)
      filename = snippet_path(name)
      return "❌ Snippet '#{name}' not found" unless File.exist?(filename)

      snippet = JSON.parse(File.read(filename))
      output = "📌 #{snippet['name']}\n"
      output += "Description: #{snippet['description']}\n"
      output += "Created: #{snippet['created_at']}\n"
      output += "Tags: #{snippet['tags'].join(', ')}\n\n"
      output += "Code:\n#{snippet['code']}\n"
      output
    end

    private

    def ensure_snippet_dir
      FileUtils.mkdir_p(SNIPPET_DIR) unless Dir.exist?(SNIPPET_DIR)
    end

    def valid_name?(name)
      name.to_s.match?(/\A[a-zA-Z0-9_-]+\z/)
    end

    def snippet_path(name)
      File.join(SNIPPET_DIR, "#{name}.json")
    end

    def extract_tags(code)
      tags = []
      tags << "class" if code.include?("class ")
      tags << "method" if code.include?("def ")
      tags << "loop" if code.match?(/\.(each|map|select|reduce)/)
      tags << "string" if code.match?(/".*"|'.*'/)
      tags << "array" if code.match?(/\[.*\]/)
      tags << "hash" if code.match?(/\{.*\}/)
      tags << "error-handling" if code.include?("begin")
      tags
    end
  end
end
