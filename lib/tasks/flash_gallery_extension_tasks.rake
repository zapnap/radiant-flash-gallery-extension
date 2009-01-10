namespace :radiant do
  namespace :extensions do
    namespace :flash_gallery do
      
      desc "Runs the migration of the Flash Gallery extension"
      task :migrate => :environment do
        require 'radiant/extension_migrator'
        if ENV["VERSION"]
          FlashGalleryExtension.migrator.migrate(ENV["VERSION"].to_i)
        else
          FlashGalleryExtension.migrator.migrate
        end
      end
      
      desc "Copies public assets of the Flash Gallery extension to the instance public/ directory."
      task :update => :environment do
        is_svn_or_dir = proc {|path| path =~ /\.svn/ || File.directory?(path) }
        Dir[FlashGalleryExtension.root + "/public/**/*"].reject(&is_svn_or_dir).each do |file|
          path = file.sub(FlashGalleryExtension.root, '')
          directory = File.dirname(path)
          puts "Copying #{path}..."
          mkdir_p RAILS_ROOT + directory
          cp file, RAILS_ROOT + path
        end
      end  
    end
  end
end
