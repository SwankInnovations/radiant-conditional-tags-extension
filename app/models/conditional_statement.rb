class ConditionalStatement
  
  attr_reader :primary_element,
              :comparison_type,
              :comparison_element,
              :err_msg
  
  def initialize(input_text)
    @input_text = input_text
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
                '([^\s\]\[]+(?:\[[^\)]*\])?)' + # number or fancy object
                ")" 
      condition_type = "([^\s]+)"
      
      diced_conditional = @input_text.scan(%r{\A\s*#{element}\s+#{condition_type}(?:\s+#{element})?\s*\Z}i).first
#      puts
#      puts "diced_conditional: " + diced_conditional.inspect
 
      if diced_conditional.empty? || diced_conditional.length != 11
        @is_valid = false
        @err_msg = "Conditional Statement not valid"
      elsif
        @is_valid = true
        @primary_element = evaluate_diced_element(diced_conditional[0, 5])
        @comparison_type = evaluate_comparison_type(diced_conditional[5])
        @comparison_element = evaluate_diced_element(diced_conditional[6, 5])
      end
    end


    def evaluate_diced_element(diced_element)
      if diced_element[0]
        diced_element[0].gsub("''", "'")
      elsif diced_element[1]
        Regexp.new(diced_element[1])
      elsif diced_element[2]
        diced_element[2].downcase == "true"
      elsif diced_element[3]
        nil
      elsif diced_element[4]
        # try to cast as float
        if (Float(diced_element[4]) rescue false)
          diced_element[4].to_f
        else
          #here's our fancy schmancy element... 
          diced_element[4]
          nil
        end
      else
        nil
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
        when 'not_equal?', '!=', '<>'
          "!="
        when 'equals?', '==', '='
          "=="
        when 'matches?', 'matches', '=~'
          "=~"
        else
          @is_valid = false
          @err_msg = "invalid comparison (#{comparison_type})"
      end
      
    end
end
