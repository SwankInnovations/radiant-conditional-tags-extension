class ConditionalTagsExtension < Radiant::Extension
  version "0.2"
  description "Adds <r:if> and <r:unless> tags to Pages, Snippets, and Layouts"
  url ""

  def activate
    Page.send :include, ConditionalTags
    load "conditional_tags/standard_evaluators.rb"
  end
end