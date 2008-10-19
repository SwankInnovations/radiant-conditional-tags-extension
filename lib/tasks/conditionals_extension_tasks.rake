namespace :radiant do
  namespace :extensions do
    namespace :conditionals do
      
      desc "Runs the migration of the Conditionals extension"
      task :migrate => :environment do
        require 'radiant/extension_migrator'
        if ENV["VERSION"]
          ConditionalsExtension.migrator.migrate(ENV["VERSION"].to_i)
        else
          ConditionalsExtension.migrator.migrate
        end
      end
      
      desc "Copies public assets of the Conditionals to the instance public/ directory."
      task :update => :environment do
        is_svn_or_dir = proc {|path| path =~ /\.svn/ || File.directory?(path) }
        Dir[ConditionalsExtension.root + "/public/**/*"].reject(&is_svn_or_dir).each do |file|
          path = file.sub(ConditionalsExtension.root, '')
          directory = File.dirname(path)
          puts "Copying #{path}..."
          mkdir_p RAILS_ROOT + directory
          cp file, RAILS_ROOT + path
        end
      end  
    end
  end
end
