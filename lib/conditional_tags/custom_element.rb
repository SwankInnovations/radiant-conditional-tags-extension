module ConditionalTags

  class CustomElement

    attr_reader :value, :identifier, :index
    @@identifiers_by_string = {}


    def initialize(input_text, tag)
      @input_text, @tag = input_text, tag
      parse_input
      if evaluator = @@identifiers_by_string[@identifier]
          element_info = { :identifier => @identifier,
                           :original_text => @input_text }
          element_info[:index] = @index if @index
          @value = evaluator.call(tag, element_info)
      else
        raise InvalidCustomElement,
              "cannot evaluate element \"#{@identifier}\""
      end
    end


    def self.register_evaluator(identifier, block)
      raise ArgumentError,
            "The match text \"#{identifier}\" is already registered" if @@identifiers_by_string.has_key? identifier
      @@identifiers_by_string[identifier] = block
    end


    private

      def parse_input
        temp_text = String.new(@input_text)
        if temp_text.slice!(/(?:\[([^\]]*)\])\Z/)
          @index = $1.strip
          if @index =~ /^"((?:[^"]|"")*)"$/
            @index = $1.gsub('""', '"')
          elsif @index =~ /^'((?:[^']|'')*)'$/
            @index = $1.gsub("''", "'")
          elsif (Float(@index) rescue false)
            @index = @index.to_f
          end
        end
        if temp_text =~ %r{\A(?:(?:\[[^\]]*\])|(?:\([^\)]*\))|[^\s\(\)\[\]])+\Z}
          @identifier = temp_text
        end
      end

  end

  class InvalidCustomElement < StandardError; end

end