require File.dirname(__FILE__) + '/../spec_helper'


module ConditionalTags
  describe "StandardEvaluators" do

    [ :primary_element, :comparison_element].each do |element_type|
      [:title, :slug, :url, :breadcrumb, :author].each do |page_property|
  
        describe "where the #{element_type.to_s.humanize.titlecase} is \"#{page_property}\"" do
          
          before :all do
            @tag = new_tag_mock
            @tag.locals.page.stub!(:title).and_return('Gettysburg Address')
            @tag.locals.page.stub!(:url).and_return("http://loghome.il.gov")
            @tag.locals.page.stub!(:slug).and_return("/speeches/disregared/war")
            @tag.locals.page.stub!(:breadcrumb).and_return("4 Score")
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
   
      
      
      
      describe "where the #{element_type.to_s.humanize.titlecase} is \"content\"" do
  
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
                @tag.locals.page.part(part).content
          end
          
        end
          
          
        it "should be invalid if no page part is given (element is \"content[]\")" do
          input_string = build_input_using("content[]", element_type)
          conditional_statement = ConditionalStatement.new(input_string, @tag)
          conditional_statement.should_not be_valid
        end
          
          
        it "should produce an err_msg if no page part is given (element is \"content[]\")" do
          input_string = build_input_using("content[]", element_type)
          conditional_statement = ConditionalStatement.new(input_string, @tag)
          conditional_statement.err_msg.should ==
              "Error in condition \"#{input_string}\" (part name not given)."
        end

        
        it "should return nil if the page part named doesn't exist (element is \"content['bogus part']\")" do
          input_string = build_input_using("content['bogus part']", element_type)
          conditional_statement = ConditionalStatement.new(input_string, @tag)
          
          conditional_statement.send(element_type).should == nil
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
              "Error in condition \"#{input_string}\" (too many parts given - only 1 allowed)."
        end
        
        
        it 'should return the content of the "body" part if no index is given (the element is "content")' do
            input_string = build_input_using("content", element_type)
            conditional_statement = ConditionalStatement.new(input_string, @tag)
            
            conditional_statement.send(element_type).should ==
                @tag.locals.page.part("body").content
        end
      end
  
  
  
  
      describe "where the #{element_type.to_s.humanize.titlecase} is \"part-names\"" do
  
        before :each do
          @tag = new_tag_mock
          part1 = mock("part1", :name => "part 1")
          part2 = mock("part2", :name => "part 2")
          part3 = mock("part3", :name => "part 3")
          @tag.locals.page.stub!(:parts).and_return([part1, part2, part3])
        end
        
        
        it "should return an array of page part names (element is \"part-names\")" do
          input_string = build_input_using("part-names", element_type)
          conditional_statement = ConditionalStatement.new(input_string, @tag)
          
          conditional_statement.send(element_type).should == ["part 1", "part 2", "part 3"]
        end
          
      end
  
  
  
  
      describe "where the #{element_type.to_s.humanize.titlecase} is \"content.count\"" do
  
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
  
  
  
  
      describe "where the #{element_type.to_s.humanize.titlecase} is \"site-mode\"" do
  
        it "should return \"dev\" if the site is in development mode" do
          Radiant::Config.stub!("[]").with('dev_host').and_return("some.development.domain")
          @tag = new_tag_mock
          @tag.globals.page.stub!(:request).and_return(mock("host", :host => "some.development.domain"))
  
          input_string = build_input_using("site-mode", element_type)
          conditional_statement = ConditionalStatement.new(input_string, @tag)
          
          conditional_statement.send(element_type).should == "dev"
        end
        
        
        it "should return \"dev\" if dev_host config value is unavailable, and the request.host value is dev.*" do
          Radiant::Config.stub!("[]").with('dev_host').and_return(nil)
          @tag = new_tag_mock
          @tag.globals.page.stub!(:request).and_return(mock("host", :host => "dev.some.site"))
  
          input_string = build_input_using("site-mode", element_type)
          conditional_statement = ConditionalStatement.new(input_string, @tag)
          
          conditional_statement.send(element_type).should == "dev"
        end
  
  
        it "should return \"live\" for all other reqest host values" do
          @tag = new_tag_mock
          @tag.globals.page.stub!(:request).and_return(mock("host", :host => "some.site"))
  
          input_string = build_input_using("site-mode", element_type)
          conditional_statement = ConditionalStatement.new(input_string, @tag)
          
          conditional_statement.send(element_type).should == "live"
        end
  
      end
  

    
    
      describe "where the #{element_type.to_s.humanize.titlecase} is \"status\"" do
  
        it "should return \"draft\" if the page.status is 1" do
          @tag = new_tag_mock
          @tag.locals.page.stub!(:status).and_return(1)
  
          input_string = build_input_using("status", element_type)
          conditional_statement = ConditionalStatement.new(input_string, @tag)
          
          conditional_statement.send(element_type).should == "draft"
        end
        
        
        it "should return \"reviewed\" if the page.status is 50" do
          @tag = new_tag_mock
          @tag.locals.page.stub!(:status).and_return(50)
  
          input_string = build_input_using("status", element_type)
          conditional_statement = ConditionalStatement.new(input_string, @tag)
          
          conditional_statement.send(element_type).should == "reviewed"
        end
        
        
        it "should return \"published\" if the page.status is 100" do
          @tag = new_tag_mock
          @tag.locals.page.stub!(:status).and_return(100)
  
          input_string = build_input_using("status", element_type)
          conditional_statement = ConditionalStatement.new(input_string, @tag)
          
          conditional_statement.send(element_type).should == "published"
        end
        
        
        it "should return \"hidden\" if the page.status is 101" do
          @tag = new_tag_mock
          @tag.locals.page.stub!(:status).and_return(101)
  
          input_string = build_input_using("status", element_type)
          conditional_statement = ConditionalStatement.new(input_string, @tag)
          
          conditional_statement.send(element_type).should == "hidden"
        end
        
      end

    
    end

  end
end