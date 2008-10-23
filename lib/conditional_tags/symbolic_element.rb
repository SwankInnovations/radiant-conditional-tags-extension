module ConditionalTags
  class SymbolicElement
    
    @@identifiers_by_string = {}
    @@instance = nil

    def initialize
      if @@instance.nil?
        # only initialize once
        @@instance = self
  
        SymbolicElement.register_evaluator("title", SimplePagePropertyEvaluator)
        SymbolicElement.register_evaluator("slug", SimplePagePropertyEvaluator)
        SymbolicElement.register_evaluator("url", SimplePagePropertyEvaluator)
        SymbolicElement.register_evaluator("breadcrumb", SimplePagePropertyEvaluator)
        SymbolicElement.register_evaluator("author", SimplePagePropertyEvaluator)
        SymbolicElement.register_evaluator("content", ContentEvaluator)
        SymbolicElement.register_evaluator("content.count", ContentCountEvaluator)
        SymbolicElement.register_evaluator("mode", ModeEvaluator)
      end
    end
    
    
    class << self
      
      
      def register_evaluator(matcher, evaluator_class)
        # instantiate the class (in case an extension tries to register an evaluator before we did ours)
        @@instance ||= new
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