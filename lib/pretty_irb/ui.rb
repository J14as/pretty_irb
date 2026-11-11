require "colorize"

module PrettyIRB
  # Shared ANSI-aware terminal layout and styling utilities.
  module UI
    ANSI_REGEX = /\e\[[0-9;]*m/.freeze

    module_function

    def colorize?
      return true unless defined?(PrettyIRB) && PrettyIRB.respond_to?(:configuration)

      PrettyIRB.configuration.colorize
    end

    def strip_ansi(text)
      text.to_s.gsub(ANSI_REGEX, "")
    end

    def visible_length(text)
      strip_ansi(text).length
    end

    def pad_right(text, width)
      padding = [width - visible_length(text), 0].max
      "#{text}#{' ' * padding}"
    end

    def paint(text, *styles)
      str = text.to_s
      return str unless colorize?

      styles.reduce(str) { |acc, style| acc.public_send(style) }
    rescue
      text.to_s
    end

    def rule(width = 62, char: "─")
      paint(char * width, :light_black)
    end

    def badge(label, color: :cyan, bold: false)
      styles = bold ? [color, :bold] : [color]
      paint("[#{label}]", *styles)
    end

    def table_row(left, right, left_width: 34, indent: 4)
      prefix = " " * indent
      "#{prefix}#{pad_right(left, left_width)}#{right}"
    end

    # Renders a rounded box with ANSI-safe width calculation and optional title.
    def box(lines, title: nil, min_width: 60, padding_x: 2)
      content_lines = Array(lines).map { |line| line == :divider ? :divider : line.to_s }
      text_lines    = content_lines.reject { |line| line == :divider }
      max_line_w    = text_lines.map { |line| visible_length(line) }.max || 0
      title_w       = title ? visible_length(title) + 4 : 0
      inner_width   = [min_width, max_line_w + (padding_x * 2), title_w].max

      top_border = build_top_border(inner_width, title)
      bottom_border = paint("╰#{'─' * inner_width}╯", :light_black)
      pad_str = " " * padding_x
      v_bar = paint("│", :light_black)

      body = content_lines.map do |line|
        if line == :divider
          paint("├#{'─' * inner_width}┤", :light_black)
        else
          padded = pad_right(line, inner_width - (padding_x * 2))
          "#{v_bar}#{pad_str}#{padded}#{pad_str}#{v_bar}"
        end
      end

      ([top_border] + body + [bottom_border]).join("\n")
    end

    def build_top_border(inner_width, title)
      if title
        label = " #{title} "
        remaining = [inner_width - 1 - visible_length(label), 1].max
        "#{paint('╭─', :light_black)}#{label}#{paint("#{'─' * remaining}╮", :light_black)}"
      else
        paint("╭#{'─' * inner_width}╮", :light_black)
      end
    end
    private_class_method :build_top_border
  end
end
