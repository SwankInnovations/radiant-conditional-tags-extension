module ConditionalTags
  class ModeEvaluator < AbstractEvaluator

    def initialize(identifier, list, full_condition, tag)
      if (dev_host = Radiant::Config['dev_host']) && (tag.globals.page.request.host == dev_host)
        @value = "dev"
      elsif tag.globals.page.request.host =~ /^dev\./
        @value = "dev"
      else
        @value = "live"
      end
      @is_valid = true
    end

  end
end