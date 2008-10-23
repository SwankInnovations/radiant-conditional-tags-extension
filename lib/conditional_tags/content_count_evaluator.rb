module ConditionalTags
  class ContentCountEvaluator < AbstractEvaluator

    def initialize(identifier, list, full_condition, tag)
      @value = tag.locals.page.parts.length
      @is_valid = true
    end

  end
end