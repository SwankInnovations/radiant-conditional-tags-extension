class ConditionalStatement
  
  attr_reader :primary_element,
              :comparison_type,
              :comparison_element,
              :err_msg
  
  def initialize(input_text, tag = nil)
    @input_text = input_text
    @tag = tag
    parse_and_interpret_input_text
    evaluate_result
  end
 
  
  def valid?
    @is_valid
  end


  def true?
    @result
  end


  private

    def parse_and_interpret_input_text
      element_regexp = "(?:" +
                "'((?:[^']|'')*)'" +   # [0] string (surrounded by "'")
                '|' +
                '/((?:[^/]|\\/)+)/' +  # [1] regexp (surounded by "/")
                '|' +
                '(true|false)' +       # [2] boolean
                '|' +
                '(nil|null|nothing)' + # [3] nil
                '|' +
                '([^\s\'\/\]\[]+)?' +  # [4] number or symbolic element w/o list
                '(?:\[([^\]]*)\])?' +  # [5] array, or list for symbolic element
                ")"
      condition_type_regexp = "([^\s]+)"
      split_input = @input_text.scan(%r{\A\s*#{element_regexp}\s+#{condition_type_regexp}(?:\s+#{element_regexp})?\s*\Z}i).first

      if split_input.nil? || split_input.length != 13
        @is_valid = false
        @err_msg = %{invalid condition "#{@input_text}"}
      else
        @is_valid = true
        @primary_element = interpret_as_element(split_input[0],
                                                split_input[1],
                                                split_input[2],
                                                split_input[3],
                                                split_input[4],
                                                split_input[5])
        @comparison_type = interpret_comparison_type(split_input[6]) if valid?
        @comparison_element = interpret_as_element(split_input[7],
                                                   split_input[8],
                                                   split_input[9],
                                                   split_input[10],
                                                   split_input[11],
                                                   split_input[12]) if valid?
      end
    end


    def interpret_comparison_type(comparison_type)
      case comparison_type.downcase
        when 'exists?'
          "exists?"
        when 'blank?', 'is-blank?'
          "blank?"
#        when 'empty?', 'is-empty?'
#          "empty?"
        when 'gt'
          ">"
        when 'lt'
          "<"
        when 'gte'
          ">="
        when 'lte'
          "<="
#        when 'is-not', 'not-equals', '!=', '<>'
#          "!="
        when 'is', 'equals', '==', '='
          "=="
        when 'matches', '=~'
          "=~"
        when 'includes', 'includes-all'
          "(&&)"
        when 'includes-any'
          "(||)"
        else
          @is_valid = false
          @err_msg = %{invalid comparison "#{comparison_type}" in condition "#{@input_text}"}
          nil
      end
    end


    def interpret_as_element(string_text,
                             regexp_text,
                             boolean_text,
                             nil_text,
                             undetermined_text,
                             array_text)
      if array_text
        array = build_array(array_text)
        return unless valid?
      end
      
      if string_text
        string_text.gsub("''", "'")

      elsif regexp_text
        Regexp.new(regexp_text)

      elsif boolean_text
        boolean_text.downcase == "true"

      elsif nil_text
        nil
      elsif undetermined_text && array
        interpret_as_symbolic_element(undetermined_text, array)

      elsif undetermined_text
        if (Float(undetermined_text) rescue false)
          undetermined_text.to_f
        else
          interpret_as_symbolic_element(undetermined_text)
        end

      elsif array
        array
      else
        nil
      end
    end


    def interpret_as_symbolic_element(identifier, list = nil)
      element = ConditionalTags::SymbolicElement.evaluate(identifier, list, @input_text, @tag)
      if element.nil?
        @is_valid = false
        @err_msg = %{unable to interpret element "#{identifier}" in condition "#{@input_text}"}
        nil
      elsif element.valid?
        element.value
      else
        @is_valid = false
        @err_msg = element.err_msg
        nil
      end
    end

  
    def build_array(items_list)
      return [] if items_list.strip.blank?
      list_copy = items_list + ","
      item_pattern = "(?:" +
             "'((?:[^']|'')*)'" + # [0] string
             "|" +
             "(\\w+)" +           # [1] number, boolean, or nil
             ")"
      items = []
      until list_copy.strip.blank?
        if list_copy.slice!(%r{\s*#{item_pattern}\s*,})
          if $1
            # must be a string (wrapped in "'" chars)
            items << $1
          else
            case $2.downcase
              when "nil", "null", "nothing"
                items << nil
              when "true"
                items << true
              when "false"
                items << false
              else
                if (Float($2) rescue false)
                  items << $2.to_f
                else
                  # parsed item doesn't match a valid type
                  items = nil
                  @is_valid = false
                  @err_msg = %{invalid list "[#{items_list}]" in condition "#{@input_text}"}
                  break
                end
            end
          end
        else
          # characters remaining in items_list that don't parse into an item
          items = nil
          @is_valid = false
          @err_msg = %{invalid list "[#{items_list}]" in condition "#{@input_text}"}
          break
        end
      end
      items
    end

  
    def evaluate_result
      return unless valid?
 
      case comparison_type
        when "=="
          @result = primary_element == comparison_element

        when "=~"
          begin
            @result = !!(primary_element =~ comparison_element)
          rescue TypeError
            @is_valid = false
            @err_msg = %{the elements in condition "#{@input_text}" cannot be compared using matching}
          end
          
        when ">"
          begin
            @result = primary_element > comparison_element
          rescue
            @is_valid = false
            @err_msg = %{the elements in condition "#{@input_text}" cannot be compared using greater-than}
          end
          
        when ">="
          begin
            @result = primary_element >= comparison_element
          rescue
            @is_valid = false
            @err_msg = %{the elements in condition "#{@input_text}" cannot be compared using greater-than-or-equal}
          end
          
        when "<"
          begin
            @result = primary_element < comparison_element
          rescue
            @is_valid = false
            @err_msg = %{the elements in condition "#{@input_text}" cannot be compared using less-than}
          end
          
        when "<="
          begin
            @result = primary_element <= comparison_element
          rescue
            @is_valid = false
            @err_msg = %{the elements in condition "#{@input_text}" cannot be compared using less-than-or-equal}
          end
          
        when "exists?"
          if comparison_element
            @is_valid = false
            @err_msg = %{the "exists?" comparison in condition "#{@input_text}" may not have a following comparison element}
          else
            @result = !primary_element.nil?
          end
      end
    end

end
