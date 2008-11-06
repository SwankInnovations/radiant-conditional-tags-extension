module ConditionalTags
  module StandardEvaluators

    include Evaluatable


    evaluator "content" do |tag, element_info|
      part_name = element_info[:index] ||= 'body'
      if part = tag.locals.page.part(part_name)
        part.content
      end
    end


    evaluator "content.count", :no_index_allowed do |tag, element_info|
      tag.locals.page.parts.length
    end


    evaluator "parts", :no_index_allowed do |tag, element_info|
      tag.locals.page.parts.map { |part| part.name }
    end


    evaluator "site-mode", :no_index_allowed do |tag, element_info|
      if (dev_host = Radiant::Config['dev_host']) && (tag.globals.page.request.host == dev_host)
        "dev"
      elsif tag.globals.page.request.host =~ /^dev\./
        "dev"
      else
        "live"
      end
    end


    evaluator "status", :no_index_allowed do |tag, element_info|
      case tag.locals.page.status
        when Status[:draft]
          "draft"
        when Status[:reviewed]
          "reviewed"
        when Status[:published]
          "published"
        when Status[:hidden]
          "hidden"
        else
          "unknown"
      end
    end


    [:title, :slug, :url, :breadcrumb, :description, :keywords].each do |page_property|
      evaluator page_property, :no_index_allowed do |tag, element_info|
        tag.locals.page.send(page_property)
      end
    end


    evaluator "created-by", :no_index_allowed do |tag, element_info|
      tag.locals.page.created_by.name
    end


    evaluator "updated-by", :no_index_allowed do |tag, element_info|
      tag.locals.page.updated_by.name
    end


    evaluator "children", :no_index_allowed do |tag, element_info|
      tag.locals.page.children.map { |child| child.title }
    end


    evaluator "children.count", :no_index_allowed do |tag, element_info|
      tag.locals.page.children.length
    end

  end
end