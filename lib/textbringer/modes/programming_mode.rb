# frozen_string_literal: true

module Textbringer
  class ProgrammingMode < FundamentalMode
    # abstract mode
    undefine_command(:programming_mode)

    define_generic_command :indent_line
    define_generic_command :newline_and_reindent
    define_generic_command :forward_definition
    define_generic_command :backward_definition
    define_generic_command :compile
    define_generic_command :toggle_test

    PROGRAMMING_MODE_MAP = Keymap.new
    PROGRAMMING_MODE_MAP.define_key("\t", :indent_line_command)
    PROGRAMMING_MODE_MAP.define_key("\n", :newline_and_reindent_command)
    PROGRAMMING_MODE_MAP.define_key("\C-c\C-n", :forward_definition_command)
    PROGRAMMING_MODE_MAP.define_key("\C-c\C-p", :backward_definition_command)
    PROGRAMMING_MODE_MAP.define_key("\C-c\C-c", :compile_command)
    PROGRAMMING_MODE_MAP.define_key("\C-ct", :toggle_test_command)

    def initialize(buffer)
      super(buffer)
      buffer.keymap = PROGRAMMING_MODE_MAP
    end

    def newline_and_reindent
      n = 1
      if indent_line
        n += 1
      end
      @buffer.save_excursion do
        pos = @buffer.point
        @buffer.beginning_of_line
        if /\A\s+\z/ =~ @buffer.substring(@buffer.point, pos)
          @buffer.delete_region(@buffer.point, pos)
          n += 1
        end
      end
      @buffer.insert("\n")
      if indent_line
        n += 1
      end
      @buffer.merge_undo(n) if n > 1
    end
  end
end
