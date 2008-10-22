class ConditionalStatement
  
  attr_reader :primary_element,
              :comparison_type,
              :comparison_element,
              :result,
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


  private

    def parse_and_interpret_input_text
      element = "(?:" +
                "'((?:[^']|'')*)'" +   # [0] string (surrounded by "'")
                '|' +
                '/((?:[^/]|\\/)+)/' +  # [1] regexp (surounded by "/")
                '|' +
                '(true|false)' +       # [2] boolean
                '|' +
                '(nil|null|nothing)' + # [3] nil
                '|' +
                '([^\s\]\[]+)?' +      # [4] number or symbolic element w/o array
                '(?:\[([^\]]*)\])?' +  # [5] array, or array for symbolic element
                ")"
      condition_type = "([^\s]+)"
      diced_conditional = @input_text.scan(%r{\A\s*#{element}\s+#{condition_type}(?:\s+#{element})?\s*\Z}i).first

      if diced_conditional.nil? || diced_conditional.length != 13
        @is_valid = false
        @err_msg = %{invalid condition "#{@input_text}"}
      elsif
        @is_valid = true
        @primary_element = interpret_as_element(diced_conditional[0, 6])
        @comparison_type = interpret_comparison_type(diced_conditional[6]) if valid?
        @comparison_element = interpret_as_element(diced_conditional[7, 6]) if valid?
      end
    end


    def interpret_comparison_type(comparison_type)
      case comparison_type.downcase
        when 'exists?'
          "exists?"
        when 'blank?', 'is_blank?'
          "blank?"
        when 'empty?', 'is_empty?'
          "empty?"
        when 'gt'
          ">"
        when 'lt'
          "<"
        when 'gte'
          ">="
        when 'lte'
          "<="
#        when 'is_not', 'not_equals', '!=', '<>'
#          "!="
        when 'is', 'equals', '==', '='
          "=="
        when 'matches', '=~'
          "=~"
        when 'includes', 'includes_all'
          "(&&)"
        when 'includes_any'
          "(||)"
        else
          @is_valid = false
          @err_msg = %{invalid comparison "#{comparison_type}" in condition "#{@input_text}"}
          nil
      end
    end


    def interpret_as_element(element_bits)
      if element_bits[0]
        element_bits[0].gsub("''", "'")
      elsif element_bits[1]
        Regexp.new(element_bits[1])
      elsif element_bits[2]
        element_bits[2].downcase == "true"
      elsif element_bits[3]
        nil
      elsif element_bits[4] && element_bits[5]
        interpret_symbolic_element(element_bits[4], element_bits[5])
      elsif element_bits[4]
        # try to cast as float
        if (Float(element_bits[4]) rescue false)
          element_bits[4].to_f
        else
          #here's our fancy schmancy element... 
          interpret_symbolic_element(element_bits[4])
        end
      elsif element_bits[5]
        build_array(element_bits[5])
      else
        nil
      end
    end


    def interpret_symbolic_element(identifier, array_item_list = nil)
      array_items = build_array(array_item_list) unless array_item_list.nil?
      return unless valid?
      case identifier
        when "title", "slug", "url", "breadcrumb", "author"
          output = @tag.locals.page.send(identifier)

        when "content"
          if array_items.nil?
            # element must have been: "content"
            part = "body"
          elsif array_items.length != 1 
            # element must have been like: "content[]" or "content[A, B, C]"
            @is_valid = false
            return nil
          else
            part = array_items.first
          end
          if @tag.locals.page.part(part)
            output = @tag.locals.page.part(part).content
          end
          
        when "parts"
          output = []
          @tag.locals.page.parts.each do |part|
            output << part.name
          end

        when "parts.count"
          output = @tag.locals.page.parts.length
          
        when "children.count"
          
        when "mode"
          if (dev_host = Radiant::Config['dev_host']) && (@tag.globals.page.request.host == dev_host)
            output = "dev"
          elsif @tag.globals.page.request.host =~ /^dev\./
            output = "dev"
          else
            output = "live"
          end
        
      end
      
      if output
        output
      else
        @is_valid = false
        @err_msg = %{unable to interpret element "#{identifier}" in condition "#{@input_text}"}
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
                  @err_msg = %{invalid array "[#{items_list}]" in condition "#{@input_text}"}
                  break
                end
            end
          end
        else
          # characters remaining in items_list that don't parse into an item
          items = nil
          @is_valid = false
          @err_msg = %{invalid array "[#{items_list}]" in condition "#{@input_text}"}
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
#              @result = true
#            else
#              @result = false
#            end
          rescue TypeError
            @is_valid = false
            @err_msg = %{element types in condition "#{@input_text}" cannot be compared using matching}
          end
          
        when ">"
          begin
            @result = primary_element > comparison_element
          rescue TypeError
            @is_valid = false
            @err_msg = %{element types in condition "#{@input_text}" cannot be compared using greater than}
          end
          
      end
    end



end
