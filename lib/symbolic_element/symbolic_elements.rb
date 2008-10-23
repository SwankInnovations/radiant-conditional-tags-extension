module SymbolicElement
  class Evaluator
    
    @@identifiers_by_string = {}
    @@instance = nil

    def initialize
      if @@instance.nil?
        # only initialize once
        @@instance = self
  
        Evaluator.register_element("title", SimplePagePropertyElement)
        Evaluator.register_element("slug", SimplePagePropertyElement)
        Evaluator.register_element("url", SimplePagePropertyElement)
        Evaluator.register_element("breadcrumb", SimplePagePropertyElement)
        Evaluator.register_element("author", SimplePagePropertyElement)
        Evaluator.register_element("content", ContentElement)
        Evaluator.register_element("content.count", ContentCountElement)
        Evaluator.register_element("mode", ModeElement)
      end
    end
    
    class << self
      
      
      def register_element(matcher, evaluator_class)
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