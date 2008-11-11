class ConditionalTagsExtension < Radiant::Extension
  version "0.4"
  description "Adds <r:if> and <r:unless> (and <r:puts>) tags to Pages, Snippets, and Layouts"
  url ""

  def activate
    Page.send :include, ConditionalTags::PageTagsExt
    ConditionalTags::CustomElement.send :include, ConditionalTags::StandardEvaluators
  end
end