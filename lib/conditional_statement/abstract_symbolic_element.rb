module Conditionals
  class AbstractSymbolicElement
    
    attr_reader :value, :err_msg
  
    def initialize(element_identifier, element_list, full_condition, tag)
      # this is the only method you need to write (overload) in your inherited classes
    end
    
    def valid?
      @is_valid
    end
    
  end
end