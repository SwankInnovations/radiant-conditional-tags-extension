module ConditionalTags
  class SimplePagePropertyEvaluator < AbstractEvaluator

    def initialize(identifier, list, full_condition, tag)
      @value = tag.locals.page.send(identifier)
      @is_valid = true
    end

  end
end