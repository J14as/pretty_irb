require "time"

module PrettyIRB
  class HistoryManager
    attr_reader :entries

    def initialize
      @entries = []
    end

    # Add entry to history
    def add(code, result = nil, error = nil)
      @entries << {
        code: code,
        result: result,
        error: error,
        timestamp: Time.now,
        line_number: @entries.length + 1
      }
    end

    # Search history by keyword
    def search(keyword)
      results = @entries.select { |entry| entry[:code].include?(keyword) }
      format_search_results(results)
    end

    # Get last N entries
    def last(n = 10)
      format_history(@entries.last(n))
    end

    # Get all history
    def all
      format_history(@entries)
    end

    # Get entry by line number
    def get(line_number)
      entry = @entries[line_number - 1]
      return "" unless entry
      "#{entry[:line_number]}: #{entry[:code]}\n=> #{entry[:result]}"
    end

    # Clear history
    def clear
      @entries = []
      "✓ History cleared"
    end

    # Export history to file
    def export(filename)
      File.write(filename, format_for_export)
      "✓ History exported to #{filename}"
    end

    private

    def format_history(entries)
      return "📋 No history" if entries.empty?

      output = "📋 History (#{entries.length} entries):\n\n"
      entries.each do |entry|
        output += "#{entry[:line_number]}: #{entry[:code]}\n"
        if entry[:result]
          output += "   => #{entry[:result]}\n"
        elsif entry[:error]
          output += "   ✗ #{entry[:error]}\n"
        end
        output += "\n"
      end
      output
    end

    def format_search_results(results)
      return "🔍 No matches found" if results.empty?

      output = "🔍 Found #{results.length} matches:\n\n"
      results.each do |entry|
        output += "#{entry[:line_number]}: #{entry[:code]}\n"
        output += "   Time: #{entry[:timestamp].strftime('%H:%M:%S')}\n\n"
      end
      output
    end

    def format_for_export
      output = "# Pretty IRB History\n"
      output += "# Generated: #{Time.now}\n\n"
      @entries.each do |entry|
        output += "# Line #{entry[:line_number]} - #{entry[:timestamp]}\n"
        output += entry[:code] + "\n"
        output += "# => #{entry[:result]}\n\n" if entry[:result]
      end
      output
    end
  end
end
