require "colorize"
require "rouge"

module PrettyIRB
  class Formatter
    INLINE_MAX_WIDTH = 72
    MAX_COLLECTION_ITEMS = 30

    class << self
      # Muted "=> " indicator so the returned value stands out clearly.
      def format_result(output)
        color("=> ", :light_black) + format_output(output)
      rescue
        "=> #{output}"
      end

      def format_output(value, indent: 0)
        case value
        when String          then color(value.inspect, :light_yellow)
        when Integer, Float  then color(value.to_s, :light_green)
        when Numeric         then color(value.to_s, :light_green)
        when TrueClass       then color("true", :cyan)
        when FalseClass      then color("false", :cyan)
        when NilClass        then color("nil", :light_black)
        when Symbol          then color(value.inspect, :light_magenta)
        when Regexp          then color(value.inspect, :light_red)
        when Range           then color(value.inspect, :light_cyan)
        when Class, Module   then color(value.inspect, :light_blue)
        when Time            then color(value.inspect, :light_cyan)
        when Array           then format_array(value, indent: indent)
        when Hash            then format_hash(value, indent: indent)
        else                      format_object(value, indent: indent)
        end
      rescue
        value.to_s
      end

      # Rouge Monokai syntax highlight for Ruby code (used in history / snippets)
      def highlight_code(code)
        return code unless syntax_highlight? && colorize?

        formatter = Rouge::Formatters::Terminal256.new(Rouge::Themes::Monokai.new)
        lexer     = Rouge::Lexers::Ruby.new
        formatter.format(lexer.lex(code))
      rescue
        code
      end

      # "ErrorType: message" — bold red type, crisp light-red detail
      def format_error(type, message = nil)
        if colorize?
          message ? type.red.bold + ": ".red + message.light_red : type.red.bold
        else
          message ? "#{type}: #{message}" : type.to_s
        end
      rescue
        "#{type}: #{message}"
      end

      def format_success(message)
        color(message, :green)
      rescue
        message
      end

      def format_warning(message)
        color(message, :yellow)
      rescue
        message
      end

      private

      def colorize?
        return true unless defined?(PrettyIRB) && PrettyIRB.respond_to?(:configuration)

        PrettyIRB.configuration.colorize
      end

      def syntax_highlight?
        return true unless defined?(PrettyIRB) && PrettyIRB.respond_to?(:configuration)

        PrettyIRB.configuration.syntax_highlight
      end

      def color(text, style)
        colorize? ? text.public_send(style) : text
      end

      def visible_length(text)
        defined?(PrettyIRB::UI) ? PrettyIRB::UI.visible_length(text) : text.gsub(/\e\[[0-9;]*m/, "").length
      end

      def format_object(value, indent: 0)
        return color(value.inspect, :light_cyan) if defined?(Date) && value.is_a?(Date)
        return format_active_record_relation(value, indent: indent) if active_record_relation?(value)
        return format_active_record_model(value, indent: indent) if active_record_model?(value)
        return format_struct(value, indent: indent) if value.is_a?(Struct)

        color(value.inspect, :white)
      end

      def active_record_relation?(value)
        defined?(ActiveRecord::Relation) && value.is_a?(ActiveRecord::Relation)
      end

      def active_record_model?(value)
        defined?(ActiveRecord::Base) && value.is_a?(ActiveRecord::Base) && value.respond_to?(:attributes)
      end

      def format_active_record_model(record, indent: 0)
        attrs = record.attributes
        klass = record.class.name || "ActiveRecord"
        new_tag = record.respond_to?(:new_record?) && record.new_record? ? color(" (new)", :yellow) : ""
        header = color("#<#{klass}", :light_cyan) + new_tag
        closing = color(">", :light_cyan)

        return "#{header} #{color('(no attributes)', :light_black)}#{closing}" if attrs.nil? || attrs.empty?

        pairs = attrs.map { |k, v| color("#{k}: ", :light_black) + format_output(v, indent: indent + 1) }
        join_collection(pairs, "#{header} ", closing, indent: indent, inline_limit: 3, inline_separator: ", ")
      rescue
        color(record.inspect, :white)
      end

      def format_active_record_relation(relation, indent: 0)
        loaded = relation.respond_to?(:loaded?) && relation.loaded?
        if loaded
          all_records = relation.to_a
          truncated   = all_records.length > MAX_COLLECTION_ITEMS
          shown       = all_records.first(MAX_COLLECTION_ITEMS)
          trunc_label = "… (#{all_records.length} total)"
        else
          fetched     = relation.limit(MAX_COLLECTION_ITEMS + 1).to_a
          truncated   = fetched.length > MAX_COLLECTION_ITEMS
          shown       = fetched.first(MAX_COLLECTION_ITEMS)
          trunc_label = "… (showing first #{MAX_COLLECTION_ITEMS})"
        end

        header  = color("#<ActiveRecord::Relation [", :light_cyan)
        closing = color("]>", :light_cyan)
        return "#{header}#{closing}" if shown.empty?

        items = shown.map { |rec| format_output(rec, indent: indent + 1) }
        items << color(trunc_label, :light_black) if truncated

        join_collection(items, header, closing, indent: indent)
      rescue
        color(relation.inspect, :white)
      end

      def format_struct(struct_obj, indent: 0)
        name = struct_obj.class.name || "Struct"
        pairs = struct_obj.to_h.map do |k, v|
          color("#{k}: ", :light_black) + format_output(v, indent: indent + 1)
        end
        header  = color("#<struct #{name}", :light_cyan)
        closing = color(">", :light_cyan)
        join_collection(pairs, "#{header} ", closing, indent: indent, inline_limit: 4)
      rescue
        color(struct_obj.inspect, :white)
      end

      def format_array(arr, indent: 0)
        return color("[]", :light_black) if arr.empty?

        items = arr.first(MAX_COLLECTION_ITEMS).map { |v| format_output(v, indent: indent + 1) }
        items << color("… (#{arr.length} total)", :light_black) if arr.length > MAX_COLLECTION_ITEMS

        join_collection(items, color("[", :light_black), color("]", :light_black), indent: indent, inline_limit: 6)
      rescue
        arr.inspect
      end

      def format_hash(hash, indent: 0)
        return color("{}", :light_black) if hash.empty?

        pairs = hash.first(MAX_COLLECTION_ITEMS).map do |k, v|
          format_output(k, indent: indent + 1) + color(" => ", :light_black) + format_output(v, indent: indent + 1)
        end
        pairs << color("… (#{hash.length} total)", :light_black) if hash.length > MAX_COLLECTION_ITEMS

        join_collection(pairs, color("{", :light_black), color("}", :light_black), indent: indent, inline_limit: 4)
      rescue
        hash.inspect
      end

      def join_collection(entries, open_delim, close_delim, indent:, inline_limit: nil, inline_separator: ", ")
        inline = "#{open_delim}#{entries.join(color(inline_separator, :light_black))}#{close_delim}"
        if inline_limit && entries.length <= inline_limit && !inline.include?("\n") && visible_length(inline) <= INLINE_MAX_WIDTH
          return inline
        end

        pad_inner = "  " * (indent + 1)
        pad_outer = "  " * indent
        body = entries.map { |entry| "#{pad_inner}#{entry}" }.join(color(",\n", :light_black))
        "#{open_delim.rstrip}\n#{body}\n#{pad_outer}#{close_delim}"
      end
    end
  end
end
