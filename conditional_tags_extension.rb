# Uncomment this if you reference any of your controllers in activate
# require_dependency 'application'

class ConditionalTagsExtension < Radiant::Extension
  version "0.1"
  description "Adds <r:if> and <r:unless> tags to Pages"
  url ""
  
  def activate
    Page.send :include, ConditionalTags
    Conditionals::SymbolicElements.new
  end
  
  def deactivate
  end
  
end