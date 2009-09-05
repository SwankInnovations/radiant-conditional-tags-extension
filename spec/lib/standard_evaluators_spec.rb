require File.dirname(__FILE__) + '/../spec_helper'


module ConditionalTags
  describe CustomElement, "(StandardEvaluators)" do

    dataset :conditional_pages, :snippets

    before :each do
      @page = pages(:child_page)
      @parent_page = pages(:parent_page)
    end


    describe 'evaluator for "content"' do

      it "should return the content for the 'body' part if no index given (actual page)" do
        @page.should render(evaluate('content')).
              and_evaluate_as(@page.part('body').content)
      end

      it "should return the content for the 'body' part if no index given (contextual page)" do
        @page.should render('<r:parent>' + evaluate('content') + '</r:parent>').
              and_evaluate_as(@parent_page.part('body').content)
      end


      it "should return the content for the 'body' part if no index given (contextual page from within a snippet)" do
        create_snippet "test", :content => '<r:parent>' + evaluate('content') + '</r:parent>'
        @page.should render('<r:snippet name="test"/>').
            and_evaluate_as(@parent_page.part('body').content)
      end


      it "should return the content for the part given in the index (actual page)" do
        @page.should render(evaluate('content[other]')).
              and_evaluate_as(@page.part('other').content)
      end

      it "should return the content for the part given in the index (contextual page)" do
        @page.should render('<r:parent>' + evaluate('content[other]') + '</r:parent>').
              and_evaluate_as(@parent_page.part('other').content)
      end


      it "should return the content for the part given in the index (contextual page from within a snippet)" do
        create_snippet "test", :content => '<r:parent>' + evaluate('content[other]') + '</r:parent>'
        @page.should render('<r:snippet name="test"/>').
            and_evaluate_as(@parent_page.part('other').content)
      end

      it "should return nil if the given part doesn't exist (actual page)" do
        @page.should render(evaluate('content[bogus]')).
              and_evaluate_as(nil)
      end

      it "should return nil if the given part doesn't exist (contextual page)" do
        @page.should render('<r:parent>' + evaluate('content[bogus]') + '</r:parent>').
              and_evaluate_as(nil)
      end


      it "should return nil if the given part doesn't exist (contextual page from within a snippet)" do
        create_snippet "test", :content => '<r:parent>' + evaluate('content[bogus]') + '</r:parent>'
        @page.should render('<r:snippet name="test"/>').and_evaluate_as(nil)
      end

    end




    describe 'evaluator for "content.count"' do

      it 'should not allow an index' do
        @page.should render(evaluate('content.count[index]')).
            with_error("content.count element cannot include an index")
      end


      it 'should return the number of page parts in the current page' do
        @page.should render(evaluate('content.count')).
            and_evaluate_as(@page.parts.length)
      end


      it 'should return the number of page parts in a contextual page' do
        @page.should render('<r:parent>' + evaluate('content.count') + '</r:parent>').
            and_evaluate_as(@parent_page.parts.length)
      end

    end




    describe 'evaluator for "parts"' do

      it 'should not allow an index' do
        @page.should render(evaluate('parts[index]')).
            with_error("parts element cannot include an index")
      end


      it 'should return an array of page part names' do
        @page.should render(evaluate('parts')).
            and_evaluate_as(@page.parts.map { |part| part.name })
      end


      it 'should return an array of page part names (contextual page)' do
        @page.should render('<r:parent>' + evaluate('parts') + '</r:parent>').
            and_evaluate_as(@parent_page.parts.map { |part| part.name })
      end

    end




    describe 'evaluator for "site-mode"' do

      it 'should not allow an index' do
        @page.should render(evaluate('site-mode[index]')).
            with_error("site-mode element cannot include an index")
      end


      it 'should return "dev" if the site is in development mode' do
        Radiant::Config.stub!("[]").with('dev_host').and_return("some.development.domain")
        @page.should render(evaluate('site-mode')).and_evaluate_as('dev').on("some.development.domain")
      end


      it 'should return "dev" if dev_host config value is unavailable, but the request.host value is dev.*' do
        Radiant::Config.stub!("[]").with('dev_host').and_return(nil)
        @page.should render(evaluate('site-mode')).and_evaluate_as('dev').on("dev.some.site")
      end


      it 'should return "live" for all other values' do
        @page.should render(evaluate('site-mode')).and_evaluate_as('live').on("any.old.domain")
      end

    end




    describe 'evaluator for "status"' do

      it 'should not allow an index' do
        @page.should render(evaluate('status[index]')).
            with_error("status element cannot include an index")
      end


      it 'should return "draft" if the status is Status[:draft]' do
        @page.status_id = Status[:draft].id
        @page.should render(evaluate('status')).and_evaluate_as('draft')
      end


      it 'should return "draft" if the status is Status[:reviewed]' do
        @page.status_id = Status[:reviewed].id
        @page.should render(evaluate('status')).and_evaluate_as('reviewed')
      end


      it 'should return "draft" if the status is Status[:published]' do
        @page.status_id = Status[:published].id
        @page.should render(evaluate('status')).and_evaluate_as('published')
      end


      it 'should return "draft" if the status is Status[:hidden]' do
        @page.status_id = Status[:hidden].id
        @page.should render(evaluate('status')).and_evaluate_as('hidden')
      end


      it 'should return "unknown" if the status is Status[:hidden]' do
        @page.status_id = 1980
        @page.should render(evaluate('status')).and_evaluate_as('unknown')
      end

    end




    [:title, :slug, :url, :breadcrumb, :description, :keywords].each do |page_property|

      describe "evaluator for \"#{page_property}\"" do

        it 'should not allow an index' do
          @page.should render(evaluate(page_property.to_s + '[index]')).
              with_error("#{page_property} element cannot include an index")
        end


        it "should return the value for page.#{page_property} (actual page)" do
          @page.should render(evaluate(page_property)).
              and_evaluate_as(@page.send(page_property))
        end


        it "should return the value for page.#{page_property} (contextual page)" do
          @page.should render('<r:parent>' + evaluate(page_property) + '</r:parent>').
              and_evaluate_as(@parent_page.send(page_property))
        end


        it "should return the value for page.#{page_property} (contextual page from within a snippet)" do
          create_snippet "test", :content => '<r:parent>' + evaluate(page_property) + '</r:parent>'
          @page.should render('<r:snippet name="test"/>').
              and_evaluate_as(@parent_page.send(page_property))
        end

      end

    end




    describe 'evaluator for "created-by"' do

      it 'should not allow an index' do
        @page.should render(evaluate('created-by[index]')).
            with_error("created-by element cannot include an index")
      end


      it 'should return the creator of the current page' do
        @page.should render(evaluate('created-by')).
            and_evaluate_as(@page.created_by.name)
      end


      it 'should return the creator of the current page (contextual page)' do
        @page.should render('<r:parent>' + evaluate('created-by') + '</r:parent>').
              and_evaluate_as(@parent_page.created_by.name)
      end

    end




    describe 'evaluator for "updated-by"' do

      it 'should not allow an index' do
        @page.should render(evaluate('updated-by[index]')).
            with_error("updated-by element cannot include an index")
      end


      it 'should return the editor of the current page (actual page)' do
        @page.should render(evaluate('updated-by')).
            and_evaluate_as(@page.updated_by.name)
      end


      it 'should return the editor of the current page (contextual page)' do
        @page.should render('<r:parent>' + evaluate('updated-by') + '</r:parent>').
              and_evaluate_as(@parent_page.updated_by.name)
      end

    end




    describe 'evaluator for "children"' do

      it 'should not allow an index' do
        @page.should render(evaluate('children[index]')).
            with_error("children element cannot include an index")
      end


      it 'should return an array of the titles for the child pages (actual page)' do
        @page.should render(evaluate('children')).
            and_evaluate_as(@page.children.map { |child| child.name })
      end


      it 'should return the number of children (contextual page)' do
        @page.should render('<r:parent>' + evaluate('children') + '</r:parent>').
              and_evaluate_as(@parent_page.children.map { |child| child.title })
      end

    end




    describe 'evaluator for "children.count"' do

      it 'should not allow an index' do
        @page.should render(evaluate('children.count[index]')).
            with_error("children.count element cannot include an index")
      end


      it 'should return the number of children (actual page)' do
        @page.should render(evaluate('children.count')).
            and_evaluate_as(@page.children.length)
      end


      it 'should return the number of children (contextual page)' do
        @page.should render('<r:parent>' + evaluate('children.count') + '</r:parent>').
              and_evaluate_as(@parent_page.children.length)
      end

    end

  end
end