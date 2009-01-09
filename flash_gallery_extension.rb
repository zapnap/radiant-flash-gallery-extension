# Uncomment this if you reference any of your controllers in activate
# require_dependency 'application'

class FlashGalleryExtension < Radiant::Extension
  GALLERY_PATH = '/galleries'
  DEFAULT_SWF  = 'slideshowpro.swf'

  version "0.1"
  description "Create and manage Flash image/media galleries with SlideShowPro" 
  url "http://github.com/zapnap/radiant-flash-gallery-extension"
  
  define_routes do |map|
    map.namespace 'admin' do |admin|
      admin.resources :galleries, :collection => { :publish => :get } do |gallery|
        gallery.resources :items, :controller => :gallery_items
      end
    end
  end
  
  def activate
    admin.tabs.add "Galleries", "/admin/galleries", :after => "Layouts", :visibility => [:all]
    Page.send :include, FlashGalleryTags
  end
  
  def deactivate
    admin.tabs.remove "Galleries"
  end
end
