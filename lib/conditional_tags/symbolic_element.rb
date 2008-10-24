module ConditionalTags
  class SymbolicElement
    
    @@identifiers_by_string = {}
    @@registry_initialized = nil

    class << self
      
      def initialize_registry
        unless @@registry_initialized
          @@registry_initialized = true
          SymbolicElement.register_evaluator("title", ConditionalTags::SimplePagePropertyEvaluator)
          SymbolicElement.register_evaluator("slug", ConditionalTags::SimplePagePropertyEvaluator)
          SymbolicElement.register_evaluator("url", ConditionalTags::SimplePagePropertyEvaluator)
          SymbolicElement.register_evaluator("breadcrumb", ConditionalTags::SimplePagePropertyEvaluator)
          SymbolicElement.register_evaluator("author", ConditionalTags::SimplePagePropertyEvaluator)
          SymbolicElement.register_evaluator("content", ConditionalTags::ContentEvaluator)
          SymbolicElement.register_evaluator("content.count", ConditionalTags::ContentCountEvaluator)
          SymbolicElement.register_evaluator("mode", ConditionalTags::ModeEvaluator)
          SymbolicElement.register_evaluator("status", ConditionalTags::StatusEvaluator)
        end
      end
      
      
      def register_evaluator(matcher, evaluator_class)
        # ensure that the registry has been initilized
        initialize_registry
        if matcher.class == String
            unless @@identifiers_by_string.has_key? matcher
              @@identifiers_by_string[matcher] = evaluator_class
            else
            raise ArgumentError,
                  %{The matcher "" is already registered},
                  caller
            end
          else
            raise TypeError,
                  %{When registering a SymbolicElementEvaluator, the matcher parameter must be a string},
                  caller
        end
      end

      
      def evaluate(element_identifier, element_list, full_statement, tag)
        if evaluator = @@identifiers_by_string[element_identifier]
          evaluator.new(element_identifier, element_list, full_statement, tag)
        end
      end
      
      
    end
    
  end
end