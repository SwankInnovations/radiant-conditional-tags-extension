require File.dirname(__FILE__) + '/../spec_helper'

describe "ConditionalTags::PageTagsExt" do
  dataset :home_page, :snippets

  before :each do
    @page = pages(:home)
  end

  describe "<r:puts> tag" do

    it 'should raise appropriate error if no "value_for" or "text" attribute is given' do
      @page.should render('<r:puts bogus="attribute" />').with_error(
        "`puts' tag must contain a 'value_for' or 'text' attribute"
      )
    end


    it 'should return the evaluated value for the custom element named' do
      @page.should render('<r:puts value_for="title" />').as(@page.title)
    end


    it 'should return the value and class if the "more" attribute is set to "true"' do
      @page.should render('<r:puts value_for="title" more="true" />').
        as(@page.title + ":" + @page.title.class.to_s)
    end

    it 'should return the evaluated value for a custom element if condition is true' do
      @page.should render('<r:puts value_for="title" if="title exists?" />').as(@page.title)
    end
    
    it 'should not return the evaluated value for a custom element if condition is false' do
      @page.should render('<r:puts value_for="title" if="false = true" />').as("")
    end

    it 'should render simple text when condition is true' do
      @page.should render('<r:puts text="hello world!" if="title exists?" />').as("hello world!")
    end

    it 'should not render simple text when condition is false' do
      @page.should render('<r:puts text="hello world!" if="false = true" />').as("")
    end

  end

end