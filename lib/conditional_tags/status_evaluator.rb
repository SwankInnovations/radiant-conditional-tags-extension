module ConditionalTags
  class StatusEvaluator < AbstractEvaluator

    def initialize(identifier, list, full_condition, tag)
      case tag.locals.page.status
        when 1
          @value = "draft"
        when 50
          @value = "reviewed"
        when 100
          @value = "published"
        when 101
          @value = "hidden"
        else
          @value = "unknown"
      end    
      @is_valid = true
    end

  end
end