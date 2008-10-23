module Conditionals
  class SymbolicElements
    
    @@identifiers_by_string = {}
    @@instance = nil

    def initialize
      if @@instance.nil?
        # only initialize once
        @@instance = self
  
        SymbolicElements.register_evaluator("title", SimplePagePropertyElement)
        SymbolicElements.register_evaluator("slug", SimplePagePropertyElement)
        SymbolicElements.register_evaluator("url", SimplePagePropertyElement)
        SymbolicElements.register_evaluator("breadcrumb", SimplePagePropertyElement)
        SymbolicElements.register_evaluator("author", SimplePagePropertyElement)
        SymbolicElements.register_evaluator("content", ContentElement)
        SymbolicElements.register_evaluator("content.count", ContentCountElement)
        SymbolicElements.register_evaluator("mode", ModeElement)
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