class ConditionalStatement
  
  attr_reader :primary_element,
              :comparison_type,
              :comparison_element,
              :err_msg
  
  def initialize(input_text, tag_bindings = nil)
    @input_text = input_text
    @tag_bindings = tag_bindings
    parse_input_text
  end
 
  
  def valid?
    @is_valid
  end

  
  def true?
    true
  end


  private

    def parse_input_text
      element = "(?:" +
                "'((?:[^']|'')*)'" +  # string (surrounded by "'")
                '|' +
                '/((?:[^/]|\\/)+)/' + # or regexp (surounded by "/")
                '|' +
                '(true|false)' + # boolean
                '|' +
                '(nil|null|nothing)' + # nil
                '|' +
                '([^\s\]\[]+(?:\[[^\]]*\])?)' + # number or fancy object
                ")" 
      condition_type = "([^\s]+)"
      
      diced_conditional = @input_text.scan(%r{\A\s*#{element}\s+#{condition_type}(?:\s+#{element})?\s*\Z}i).first
#      puts
#      puts "diced_conditional: " + diced_conditional.inspect
 
      if diced_conditional.nil? || diced_conditional.length != 11
        @is_valid = false
        @err_msg = %{invalid condition "#{@input_text}"}
      elsif
        @is_valid = true
        @primary_element = evaluate_element(diced_conditional[0, 5])
        @comparison_type = evaluate_comparison_type(diced_conditional[5]) if valid?
        @comparison_element = evaluate_element(diced_conditional[6, 5]) if valid?
      end
    end


    def evaluate_comparison_type(comparison_type)
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
        else
          @is_valid = false
          @err_msg = %{invalid comparison "#{comparison_type}" in condition "#{@input_text}"}
          nil
      end
    end


    def evaluate_element(element_array)
      if element_array[0]
        element_array[0].gsub("''", "'")
      elsif element_array[1]
        Regexp.new(element_array[1])
      elsif element_array[2]
        element_array[2].downcase == "true"
      elsif element_array[3]
        nil
      elsif element_array[4]
        # try to cast as float
        if (Float(element_array[4]) rescue false)
          element_array[4].to_f
        else
          #here's our fancy schmancy element... 
          evaluate_symbolic_element element_array[4]
        end
      else
        nil
      end
    end


    def evaluate_symbolic_element(element_string)
      if (/^(\w+(?:\.\w+)*)(?:\[([^\]]*)\])?$/).match(element_string).nil?
        @is_valid = false
        @err_msg = %{invalid syntax for element "#{element_string}" in condition "#{@input_text}"}
        nil
      else
        case $1
          when "title", "slug", "url", "breadcrumb", "author"
            @tag_bindings.page.send($1)

          when "content" #, part
            part = $2
            part = "body" if part.blank?
            if @tag_bindings.page.part(part)
              @tag_bindings.page.part(part).content
            else
              nil
            end
            
          when "parts"
            output = ""
            @tag_bindings.page.parts.each do |part|
              output << part.name + ";"
            end
            output.chop

          when "parts.count"
            @tag_bindings.page.parts.length
            
          when "children.count"
            
          when "mode"
            if (dev_host = Radiant::Config['dev_host']) && (@tag_bindings.page.request.host == dev_host)
              "dev"
            elsif @tag_bindings.page.request.host =~ /^dev\./
              "dev"
            else
              "live"
            end
          
          else
            @is_valid = false
            @err_msg = %{unable to evaluate element "#{element_string}" in condition "#{@input_text}"}
            nil
        end
      end
    end

  
  
end
