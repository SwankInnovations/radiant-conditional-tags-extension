# These modules are available to be invoked during testing/specs. They offer
# utility tags and matchers so that tests/specs can get at values only available
# within tag contexts

module EvaluatorsTestTag
  include Radiant::Taggable
    tag 'evaluate' do |tag|
      custom_element = ConditionalTags::CustomElement.new(tag.attr['element'], tag)
      "#{custom_element.value.inspect}:#{custom_element.value.class}"
    end
end
Page.send :include, EvaluatorsTestTag


module EvaluationMatcher
  def and_evaluate_as(value)
    @expected = "#{value.inspect}:#{value.class}"
    self
  end
end
Spec::Rails::Matchers::RenderTags.send :include, EvaluationMatcher