module ConditionalTags

  class ConditionalStatement

    attr_reader :primary_element,
                :comparison_type,
                :comparison_element


    def initialize(input_text, tag = nil)
      @input_text, @tag = input_text, tag
      begin
        parse_and_interpret_input_text
        @result = evaluate_result
      rescue InvalidConditionalStatement
        raise InvalidConditionalStatement,
              "Error in condition \"#{@input_text}\" (#{$!})"
      rescue InvalidCustomElement
        raise InvalidConditionalStatement,
              "Error in condition \"#{@input_text}\" (#{$!})"
      end
    end


    def true?
      @result
    end


    private

      def parse_and_interpret_input_text
        element_regexp = "(?:" +
                  "'((?:[^']|'')*)'" +   # [0] string (surrounded by ")
                  '|' +
                  '"((?:[^"]|"")*)"' +   # [1] string (surrounded by ')
                  '|' +
                  '/((?:[^/]|\\/)+)/' +  # [2] regexp (surounded by "/")
                  '|' +
                  '(true|false)' +       # [3] boolean
                  '|' +
                  '(nil|null|nothing)' + # [4] nil
                  '|' +
                  '((?:(?:\[[^\]]*\])|(?:\([^\)]*\))|[^\s\(\)\[\]])+)' + # [5] number, list, or custom element
                  ")"
        condition_type_regexp = "([^\s]+)"
        split_input = @input_text.scan(%r{\A\s*#{element_regexp}\s+#{condition_type_regexp}(?:\s+#{element_regexp})?\s*\Z}i).first

        if split_input.nil? || split_input.length != 13
          raise InvalidConditionalStatement,
                "could not parse condition"
        else
          @primary_element = interpret_as_element(split_input[0] ||= split_input[1],
                                                  split_input[2],
                                                  split_input[3],
                                                  split_input[4],
                                                  split_input[5])
          @comparison_type = interpret_comparison_type(split_input[6])
          @comparison_element = interpret_as_element(split_input[7] ||= split_input[8],
                                                     split_input[9],
                                                     split_input[10],
                                                     split_input[11],
                                                     split_input[12])
        end
      end


      def interpret_comparison_type(comparison_type)
        case comparison_type.downcase
          when 'exists?'
            "exists?"
          when 'blank?', 'is-blank?'
            "blank?"
          when 'gt'
            ">"
          when 'lt'
            "<"
          when 'gte'
            ">="
          when 'lte'
            "<="
          when 'is', 'equals', '==', '='
            "=="
          when 'matches', '=~'
            "=~"
          when 'includes', 'includes-all'
            "(&&)"
          when 'includes-any'
            "(||)"
          else
            raise InvalidConditionalStatement,
                  "invalid comparison \"#{comparison_type}\""
            nil
        end
      end


      def interpret_as_element(string_text,
                               regexp_text,
                               boolean_text,
                               nil_text,
                               undetermined_text)
        if string_text
          string_text.gsub("''", "'").gsub('""', '"')
        elsif regexp_text
          Regexp.new(regexp_text)
        elsif boolean_text
          boolean_text.downcase == "true"
        elsif nil_text
          nil
        elsif undetermined_text
          # test if an array
          if undetermined_text =~ /\A\[([^\]]*)\]\Z/
            build_array($1)
          # test if a number
          elsif (Float(undetermined_text) rescue false)
            undetermined_text.to_f
          else
            CustomElement.new(undetermined_text, @tag).value
          end
        else
          nil
        end
      end


      def build_array(items_list)
        return [] if items_list.strip.blank?
        list_copy = items_list + ","
        item_pattern = "(?:" +
               "'((?:[^']|'')*)'" + # [0] string (wrapped in ')
               "|" +
               '"((?:[^"]|"")*)"' + # [1] string (wrapped in ")
               "|" +
               "(\\w+)" +           # [2] number, boolean, or nil
               ")"
        items = []
        until list_copy.strip.blank?
          if list_copy.slice!(%r{\s*#{item_pattern}\s*,})
            if $1
              # must be a string (wrapped in ' chars)
              items << $1.gsub("''", "'")
            elsif $2
              # must be a string (wrapped in " chars)
              items << $2.gsub('""', '"')
            else
              case $3.downcase
                when "nil", "null", "nothing"
                  items << nil
                when "true"
                  items << true
                when "false"
                  items << false
                else
                  if (Float($3) rescue false)
                    items << $3.to_f
                  else
                    # parsed item doesn't match a valid type
                    items = nil
                    raise InvalidConditionalStatement,
                          "invalid list \"[#{items_list}]\""
                    break
                  end
              end
            end
          else
            # characters remaining in items_list that don't parse into an item
            items = nil
            raise InvalidConditionalStatement,
                  "invalid list \"[#{items_list}]\""
            break
          end
        end
        items
      end


      def evaluate_result
        case comparison_type
          when "=="
            primary_element == comparison_element

          when "=~"
            begin
              !!(primary_element =~ comparison_element)
            rescue TypeError
              raise InvalidConditionalStatement,
                    "these elements cannot be compared using matches"
            end

          when ">"
            begin
              primary_element > comparison_element
            rescue
              raise InvalidConditionalStatement,
                    "these elements cannot be compared using greater-than"
            end

          when ">="
            begin
              primary_element >= comparison_element
            rescue
              raise InvalidConditionalStatement,
                    "these elements cannot be compared using greater-than-or-equal"
            end

          when "<"
            begin
              primary_element < comparison_element
            rescue
              raise InvalidConditionalStatement,
                    "these elements cannot be compared using less-than"
            end

          when "<="
            begin
              primary_element <= comparison_element
            rescue
              raise InvalidConditionalStatement,
                    "these elements cannot be compared using less-than-or-equal"
            end

          when "exists?"
            if comparison_element
              raise InvalidConditionalStatement,
                    "the exists? comparison cannot be followed by a comparison element"
            else
              !primary_element.nil?
            end

          when "(&&)"
            if (primary_element.class == Array) && (comparison_element.class == Array)
              uniq_comparison_array = comparison_element.uniq
              (primary_element & uniq_comparison_array).length ==uniq_comparison_array.length
            else
              raise InvalidConditionalStatement,
                    "only lists can be compared using 'includes'"
            end

          when "(||)"
            if (primary_element.class == Array) && (comparison_element.class == Array)
              !(primary_element & comparison_element).empty? || comparison_element.empty?
            else
              raise InvalidConditionalStatement,
                    "only lists can be compared using 'includes-any'"
            end
        end
      end

  end
end