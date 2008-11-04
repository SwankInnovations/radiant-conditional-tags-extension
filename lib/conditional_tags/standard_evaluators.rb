module ConditionalTags
  module StandardEvaluators

    include Evaluatable
    
    evaluator "content" do |tag, element|
      part_name = element[:index] ||= 'body'
      if part = tag.locals.page.part(part_name)
        part.content
      end
    end


    evaluator "content.count", :no_index_allowed do |tag, element|
      tag.locals.page.parts.length
    end

  
    evaluator "part-names", :no_index_allowed do |tag, element|
      value = []
      tag.locals.page.parts.each do |part|
        value << part.name
      end
      value
    end
  
  
    evaluator "site-mode", :no_index_allowed do |tag, element|
      if (dev_host = Radiant::Config['dev_host']) && (tag.globals.page.request.host == dev_host)
        "dev"
      elsif tag.globals.page.request.host =~ /^dev\./
        "dev"
      else
        "live"
      end
    end


    evaluator "status", :no_index_allowed do |tag, element|
      case tag.locals.page.status
        when 1
          "draft"
        when 50
          "reviewed"
        when 100
          "published"
        when 101
          "hidden"
        else
          "unknown"
      end
    end


    [:title, :slug, :url, :breadcrumb, :author].each do |page_property|
      evaluator page_property, :no_index_allowed do |tag, element|
        tag.locals.page.send(page_property)
      end
    end


    evaluator "name", :no_index_allowed do |tag, element|
      tag.locals.page.title
    end
  
  end
end