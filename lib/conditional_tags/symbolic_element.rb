module ConditionalTags
  class SymbolicElement
    
    @@identifiers_by_string = {}
    @@registry_initialized = nil

    attr_reader :value

    def initialize(identifier, index, tag)
      @identifier, @index, @tag = identifier, index, tag
      if evaluator = @@identifiers_by_string[@identifier]
          element_info = { :identifier => @identifier }
          element_info[:index] = @index if @index
          @value = evaluator.call(tag, element_info)
      else
        raise InvalidSymbolicElement,
              "(cannot interpret element \"#{@identifier}\")"
      end
    end


    class << self
      
      def initialize_registry
        unless @@registry_initialized
          @@registry_initialized = true
          include ConditionalTags::StandardEvaluators
        end
      end
      
      
      def register_evaluator(identifier, block)
        initialize_registry
        if identifier.class == String
          unless @@identifiers_by_string.has_key? identifier
            @@identifiers_by_string[identifier] = block
          else
            raise ArgumentError,
                  "The match text \"#{identifier}\" is already registered"
          end
        else
          raise TypeError,
                "When registering a SymbolicElementEvaluator, the identifier parameter must be a string"
        end
      end

    end
    
  end
end