class ConditionalTagsExtension < Radiant::Extension
  version "0.2"
  description "Adds <r:if> and <r:unless> tags to Pages, Snippets, and Layouts"
  url ""
  
  def activate
    Page.send :include, ConditionalTags
    ConditionalTags::SymbolicElement.initialize_registry
    require File.dirname(__FILE__) + '/lib/wacky_radius'
  end
end