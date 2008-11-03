unless defined? RADIANT_ROOT
  ENV["RAILS_ENV"] = "test"
  case
  when ENV["RADIANT_ENV_FILE"]
    require ENV["RADIANT_ENV_FILE"]
  when File.dirname(__FILE__) =~ %r{vendor/radiant/vendor/extensions}
    require "#{File.expand_path(File.dirname(__FILE__) + "/../../../../../../")}/config/environment"
  else
    require "#{File.expand_path(File.dirname(__FILE__) + "/../../../../")}/config/environment"
  end
end
require "#{RADIANT_ROOT}/spec/spec_helper"

if File.directory?(File.dirname(__FILE__) + "/scenarios")
  Scenario.load_paths.unshift File.dirname(__FILE__) + "/scenarios"
end
if File.directory?(File.dirname(__FILE__) + "/matchers")
  Dir[File.dirname(__FILE__) + "/matchers/*.rb"].each {|file| require file }
end


def build_input_using(element_value, element_type = :primary_element)
  if element_type == :primary_element
    input_string = element_value.to_s + " == 'ignore this'"
  else
    input_string = "'some value' == " + element_value.to_s        
  end
end


def new_tag_mock
  local_page = mock("local page")
  local_page.stub!(:parts).and_return(nil)
  local_page.stub!(:part).and_return(nil)
  locals = mock("locals", :page => local_page)
  global_page = mock("master page")
  global_page.stub!(:parts).and_return(nil)
  global_page.stub!(:part).and_return(nil)
  globals = mock("globals", :page => global_page)
  tag = mock("tag")
  tag.stub!(:globals).and_return(globals)
  tag.stub!(:locals).and_return(locals)
  tag
end




Spec::Runner.configure do |config|
  # config.use_transactional_fixtures = true
  # config.use_instantiated_fixtures  = false
  # config.fixture_path = RAILS_ROOT + '/spec/fixtures'

  # You can declare fixtures for each behaviour like this:
  #   describe "...." do
  #     fixtures :table_a, :table_b
  #
  # Alternatively, if you prefer to declare them only once, you can
  # do so here, like so ...
  #
  #   config.global_fixtures = :table_a, :table_b
  #
  # If you declare global fixtures, be aware that they will be declared
  # for all of your examples, even those that don't use them.
end