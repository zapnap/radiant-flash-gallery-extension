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
        mkdir_p("#{RAILS_ROOT}/public/galleries")
      end  
    end
  end
end
