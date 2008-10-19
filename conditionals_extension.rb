# Uncomment this if you reference any of your controllers in activate
# require_dependency 'application'

class ConditionalsExtension < Radiant::Extension
  version "1.0"
  description "Describe your extension here"
  url "http://yourwebsite.com/conditionals"
  
  # define_routes do |map|
  #   map.connect 'admin/conditionals/:action', :controller => 'admin/conditionals'
  # end
  
  def activate
    # admin.tabs.add "Conditionals", "/admin/conditionals", :after => "Layouts", :visibility => [:all]
  end
  
  def deactivate
    # admin.tabs.remove "Conditionals"
  end
  
end