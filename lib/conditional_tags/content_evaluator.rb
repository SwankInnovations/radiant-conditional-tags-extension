module ConditionalTags
  class ContentEvaluator < AbstractEvaluator

    def initialize(identifier, list = nil, full_condition = nil, tag = nil)
      if list.nil?
        # element must have been: "content"
        @value = []
        tag.locals.page.parts.each do |part|
          @value << part.name
        end
        @is_valid = true
      elsif list.length > 1 
        # element must have been like: "content[A, B, C]"
        @is_valid = false
        @err_msg = %{only one content tab can be named in "content[]" in condition "#{full_condition}"}
        @value = nil
      else
        # element is either content[] or content['some part']
        part = list.first || "body"
        @value = tag.locals.page.part(part).content
        @is_valid = true
      end
    end

  end
end