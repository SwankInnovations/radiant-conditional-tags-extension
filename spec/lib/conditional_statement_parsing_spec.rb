require File.dirname(__FILE__) + '/../spec_helper'


def build_input_using(element_value, element_type = :primary_element)
  if element_type == :primary_element
    input_string = element_value.to_s + " == 'ignore this'"
  else
    input_string = "'ignore this' == " + element_value.to_s        
  end
end


def new_tag_mock
  local_page = mock("local page")
  locals = mock("locals", :page => local_page)
  global_page = mock("master page")
  globals = mock("globals", :page => global_page)
  tag = mock("tag")
  tag.stub!(:globals).and_return(globals)
  tag.stub!(:locals).and_return(locals)
  tag
end




describe ConditionalStatement do
  
  it "should not permit insantiation without a paramter" do
    lambda{conditional_statement = ConditionalStatement.new}.
        should raise_error(ArgumentError)
  end




  describe "with valid input" do
    [ { :input => "10 == 5", :output => "==" },
      { :input => "10 = 5", :output => "==" },
      { :input => "10 is 5", :output => "==" },
      { :input => "10 equals 5", :output => "==" },
      
#      { :input => "10 != 5", :output => "!=" },
#      { :input => "10 <> 5", :output => "!=" },
#      { :input => "10 is_not 5", :output => "!=" },
#      { :input => "10 not_equals 5", :output => "!=" },
#      
      { :input => "10 =~ 5", :output => "=~" },
      { :input => "10 matches 5", :output => "=~" },
      
      { :input => "10 includes 5", :output => "(&&)" },
      { :input => "10 includes-all 5", :output => "(&&)" },
      { :input => "10 includes-any 5", :output => "(||)" },
      
      { :input => "10 gt 5", :output => ">" },
      { :input => "10 GT 5", :output => ">" },
      
      { :input => "10 lt 5", :output => "<" },
      { :input => "10 LT 5", :output => "<" },
      
      { :input => "10 gte 5", :output => ">=" },
      { :input => "10 GTE 5", :output => ">=" },
      
      { :input => "10 lte 5", :output => "<=" },
      { :input => "10 LTE 5", :output => "<=" },
      
      { :input => "'test' blank?", :output => "blank?" },
      { :input => "'test' is-blank?", :output => "blank?" },
      
#      { :input => "'test' empty?", :output => "empty?" },
#      { :input => "'test' is-empty?", :output => "empty?" },
#      
      { :input => "'test' exists?", :output => "exists?" }
    ].each do |current_cond|
      
      describe "(#{current_cond[:input]})" do
        
        before :all do
          @conditional_statement = ConditionalStatement.new(current_cond[:input])
        end

        it "should be valid" do
          @conditional_statement.should be_valid
        end
        
        it "should properly interpret the Comparison Type" do
          @conditional_statement.comparison_type.should == current_cond[:output]
        end
        
      end
      
    end
  
  
  
  
 
    [ { :input => "'string'", :output => "string" },
      { :input => " 'a string' ", :output => "a string" },
      { :input => "  'a very long string'", :output => "a very long string" },
      { :input => "'a string with it''s apostrophe'   ", :output => "a string with it's apostrophe" },
      { :input => %{'a string with odd characters ($#^*@\%&;:,.<>[]{}=+-_`~?)'}, :output => %{a string with odd characters ($#^*@\%&;:,.<>[]{}=+-_`~?)} },

      { :input => "false", :output => false },
      { :input => "False", :output => false },
      { :input => "FALSE", :output => false },
      { :input => "FaLsE", :output => false },
      { :input => "falsE", :output => false },

      { :input => "true", :output => true },
      { :input => "True", :output => true },
      { :input => "TRUE", :output => true },
      { :input => "TrUe", :output => true },
      { :input => "truE", :output => true },

      { :input => '/regexp/', :output => /regexp/ },
      { :input => '/\A((?:[^\s])*|(cat dog))$/   ', :output => /\A((?:[^\s])*|(cat dog))$/ },
      { :input => '   /\b(?:\d{1,3}\.){3}\d{1,3}\b/ ', :output => /\b(?:\d{1,3}\.){3}\d{1,3}\b/ },

      { :input => "10", :output => 10 },
      { :input => " -10  ", :output => -10 },
      { :input => "  5.25 ", :output => 5.25 },
      { :input => "-5.25   ", :output => -5.25 },
      { :input => "   +101.25", :output => 101.25 },

      { :input => "[]", :output => [] },
      { :input => "[10, 11, 12]", :output => [10, 11, 12] },
      { :input => "['a', 'b' ,'c']", :output => ['a', 'b', 'c'] },
      { :input => "[true, FALSE, tRuE]", :output => [true, false, true] },
      { :input => "[nil, null , NOTHING]", :output => [nil, nil, nil] },
      { :input => "[10, 'b', TRUE]", :output => [10, 'b', true] }
    
    ].each do |current_element|
      [ :primary_element, :comparison_element ].each do |element_type|

        input_string = build_input_using(current_element[:input], element_type)

        describe "where the #{element_type.to_s.humanize.titlecase} is a literal (#{input_string})" do

          before :all do
            @conditional_statement = ConditionalStatement.new(input_string)
          end
          
          it "should be valid" do
            @conditional_statement.should be_valid
          end
        
          it "should properly interpret the literal" do
            @conditional_statement.send(element_type).should == current_element[:output]
          end
          
        end
         
      end
    end

  end



  
  describe "with invalid conditions" do
    [ "",
      "a b c d",
      "100",
    ].each do |condition|
      
      describe "(#{condition})" do
        
        before :all do
          @conditional_statement = ConditionalStatement.new(condition)
        end
        
        it "should not be valid" do
          @conditional_statement.should_not be_valid
        end
        
        it "should produce the proper error message" do
          @conditional_statement.err_msg.should == "invalid condition \"#{condition}\""
        end
        
      end
  
    end
  end
  
  
  
  
  describe "with malformed conditions" do
    [ { :input => "'abc' /abc/ 12", :comparison => "/abc/" },
      { :input => "100 ??? 12", :comparison => "???"  },
    ].each do |condition|
      
      describe "(#{condition[:input]})" do
        
        before :all do
          @conditional_statement = ConditionalStatement.new(condition[:input])
        end
        
        it "should not be valid" do
          @conditional_statement.should_not be_valid
        end
        
        it "should produce the proper error message" do
          @conditional_statement.err_msg.should ==
              "invalid comparison \"#{condition[:comparison]}\" in condition \"#{condition[:input]}\""
        end
        
      end
      
    end
  end
  
  
  
  
  [ :primary_element, :comparison_element].each do |element_type|

    [ "['g' 'h' 'i']",
      "[ a ]",
      "['a' ,  a  ]",
      "[true\t 10]"
    ].each do |element|

      describe "with conditions having malformed array elements" do

        before :each do
          @input_string = build_input_using(element, element_type)
          @conditional_statement = ConditionalStatement.new(@input_string)
        end
        
        it "should not be valid (using: #{@input_string})" do
          @conditional_statement.should_not be_valid
        end
        
        it "should produce the proper error message" do
          @conditional_statement.err_msg.should == 
              "invalid list \"#{element}\" in condition \"#{@input_string}\""
        end
        
      end
    end
      
      
      
      
    [ {:input => "abc.def['g' 'h' 'i']", :array => "['g' 'h' 'i']"},
      {:input => "abc[a]", :array => "[a]"},
      {:input => "abc['a', a]", :array => "['a', a]"},
      {:input => "abc[true\t 10]", :array => "[true\t 10]"}
    ].each do |element|

      describe "with conditions having symbolic elements with malformed array elements" do

        before :each do
          @input_string = build_input_using(element[:input], element_type)
          @conditional_statement = ConditionalStatement.new(@input_string)
        end
        
        it "should not be valid (using: #{@input_string})" do
          @conditional_statement.should_not be_valid
        end
        
        it "should produce the proper error message" do
          @conditional_statement.err_msg.should == 
              "invalid list \"#{element[:array]}\" in condition \"#{@input_string}\""
        end
        
      end
    end
    
    
    
    
    [ { :input => "abc.def[10]", :identifier => "abc.def" },
      { :input => "jabber", :identifier => "jabber" },
      { :input => "jub.jub['bird']", :identifier => "jub.jub" }
    ].each do |element|
          
      describe "with conditions containing unknown symbolic element identifiers" do

        before :all do
          @input_string = build_input_using(element[:input], element_type)
          @conditional_statement = ConditionalStatement.new(@input_string)
        end
        
        it "should not be valid (using: #{@input_string})" do
          @conditional_statement.should_not be_valid
        end
        
        it "should produce the proper error message" do
          @conditional_statement.err_msg.should == 
              "unable to interpret element \"#{element[:identifier]}\" in condition \"#{@input_string}\""
        end
          
      end
        
    end

  
  end

  

    
  [ :primary_element, :comparison_element].each do |element_type|
    [:title, :slug, :url, :breadcrumb, :author].each do |page_property|

      describe "when the #{element_type.to_s.humanize.titlecase} is \"#{page_property}\"" do
        
        before :all do
          @tag = new_tag_mock
          @tag.locals.page.stub!(:title).and_return('Gettysburg Address')
          @tag.locals.page.stub!(:url).and_return("http://loghome.il.gov")
          @tag.locals.page.stub!(:slug).and_return("/speeches/disregared/war")
          @tag.locals.page.stub!(:breadcrumb).and_return("4 Score +")
          @tag.locals.page.stub!(:author).and_return("Abraham Lincoln")
        end
  
        it "should return the value for page.#{page_property} (from the given page binding)" do
          input_string = build_input_using(page_property, element_type)
          conditional_statement = ConditionalStatement.new(input_string, @tag)
          
          conditional_statement.send(element_type).should ==
              @tag.locals.page.send(page_property)
        end
        
      end
 
    end
 
    
    
    
    describe "when the #{element_type.to_s.humanize.titlecase} is \"content[]\"" do

      before :each do
        @tag = new_tag_mock
        @tag.locals.page.stub!(:part).with("body").and_return(mock("body", :content => "My Body's Content"))
        @tag.locals.page.stub!(:part).with("other part").and_return(mock("other", :content => "Some Other Content"))
        @tag.locals.page.stub!(:part).with("another part").and_return(mock("other", :content => "Some More Content"))
      end
      
      ["body", "other part", "another part"]. each do |part|
        
        it "should return the content of the \"#{part}\" part (element is \"content['#{part}']\")" do
          input_string = build_input_using("content['#{part}']", element_type)
          conditional_statement = ConditionalStatement.new(input_string, @tag)
          
          conditional_statement.send(element_type).should ==
              @tag.locals.page.send("part", part).content
        end
        
      end
        
        
      it "should return the content of the \"body\" part (element is \"content[]\")" do
        input_string = build_input_using("content[]", element_type)
        conditional_statement = ConditionalStatement.new(input_string, @tag)
        
        conditional_statement.send(element_type).should ==
            @tag.locals.page.part("body").content
      end
        
        
      it "should return nil if the page part named doesn't exist (element is \"content['bogus']\")" do
        input_string = build_input_using("content[]", element_type)
        conditional_statement = ConditionalStatement.new(input_string, @tag)
        
        conditional_statement.send(element_type).should ==
            @tag.locals.page.part("body").content
      end
        
        
      it "should be invalid if multiple page parts are given (the element is \"content['item1', 'item2']\")" do
        input_string = build_input_using("content['body', 'other part']", element_type)
        conditional_statement = ConditionalStatement.new(input_string, @tag)
        conditional_statement.should_not be_valid
      end
        
        
      it "should produce an err_msg if multiple page parts are given (the element is \"content['item1', 'item2']\")" do
        input_string = build_input_using("content['body', 'other part']", element_type)
        conditional_statement = ConditionalStatement.new(input_string, @tag)
        conditional_statement.err_msg.should ==
            "only one content tab can be named in \"content[]\" in condition \"#{input_string}\""
      end
        
    end




    describe "when the #{element_type.to_s.humanize.titlecase} is \"content\"" do

      before :each do
        @tag = new_tag_mock
        part1 = mock("part1", :name => "part 1")
        part2 = mock("part2", :name => "part 2")
        part3 = mock("part3", :name => "part 3")
        @tag.locals.page.stub!(:parts).and_return([part1, part2, part3])
      end
      
      
      it "should return an array of page part names (element is \"content\")" do
        input_string = build_input_using("content", element_type)
        conditional_statement = ConditionalStatement.new(input_string, @tag)
        
        conditional_statement.send(element_type).should == ["part 1", "part 2", "part 3"]
      end
        
    end




    describe "when the #{element_type.to_s.humanize.titlecase} is \"content.count\"" do

      before :each do
        @tag = new_tag_mock
        part1 = mock("part1", :name => "part 1")
        part2 = mock("part2", :name => "part 2")
        part3 = mock("part3", :name => "part 3")
        @tag.locals.page.stub!(:parts).and_return([part1, part2, part3])
      end
      
      it "should return a the number of page parts" do
        input_string = build_input_using("content.count", element_type)
        conditional_statement = ConditionalStatement.new(input_string, @tag)
        
        conditional_statement.send(element_type).should == 3
      end
        
    end




    describe "when the #{element_type.to_s.humanize.titlecase} is \"mode\"" do

      it "should return \"dev\" if the site is in development mode" do
        Radiant::Config.stub!("[]").with('dev_host').and_return("some.development.domain")
        @tag = new_tag_mock
        @tag.globals.page.stub!(:request).and_return(mock("host", :host => "some.development.domain"))

        input_string = build_input_using("mode", element_type)
        conditional_statement = ConditionalStatement.new(input_string, @tag)
        
        conditional_statement.send(element_type).should == "dev"
      end
      
      
      it "should return \"dev\" if dev_host config value is unavailable, and the request.host value is dev.*" do
        Radiant::Config.stub!("[]").with('dev_host').and_return(nil)
        @tag = new_tag_mock
        @tag.globals.page.stub!(:request).and_return(mock("host", :host => "dev.some.site"))

        input_string = build_input_using("mode", element_type)
        conditional_statement = ConditionalStatement.new(input_string, @tag)
        
        conditional_statement.send(element_type).should == "dev"
      end


      it "should return \"live\" for all other reqest host values" do
        @tag = new_tag_mock
        @tag.globals.page.stub!(:request).and_return(mock("host", :host => "some.site"))

        input_string = build_input_using("mode", element_type)
        conditional_statement = ConditionalStatement.new(input_string, @tag)
        
        conditional_statement.send(element_type).should == "live"
      end

    end

  end
    
end