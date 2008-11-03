module ConditionalTags
  class SymbolicElement
    
    @@identifiers_by_string = {}
    @@registry_initialized = nil


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
                  %{The match text "#{identifier}" is already registered},
                  caller
          end
        else
          puts
          puts
          puts identifier.inspect
          raise TypeError,
                %{When registering a SymbolicElementEvaluator, the identifier parameter must be a string},
                caller
        end
      end

      
      def evaluate(element_identifier, element_list, full_statement, tag)
        if evaluator = @@identifiers_by_string[element_identifier]
            element_info = { :identifier => element_identifier,
                             :original_text => full_statement }
            element_info[:index] = element_list if element_list
            evaluator.call(tag, element_info)
        else
          raise NoMatchingEvaluator,
                "(cannot interpret element \"#{element_identifier}\")"
        end
      end
      
    end
    
  end
end