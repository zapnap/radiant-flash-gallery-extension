module FlashGalleryTags
  include Radiant::Taggable

  class TagError < StandardError; end

  desc %{
    Display a Flash gallery. You must specify the gallery name.
    Height and width parameters are also required.

    *Usage:*
    <pre><code><r:gallery name="My Portfolio" height="200" width="300"/></code></pre>
  }
  tag 'gallery' do |tag|
    if (gallery = Gallery.find_by_title(tag.attr['name'])) && (height = tag.attr['height']) && (width = tag.attr['width'])
      out = "<object classid='clsid:D27CDB6E-AE6D-11cf-96B8-444553540000' codebase='http://download.macromedia.com/pub/shockwave/cabs/flash/swflash.cab#version=9,0,28,0' id='#{tag.attr['id'] || gallery.title.to_permalink}'>"
      out += "<param name='movie' value='#{gallery.swf.url}' />"
      out += "<param name='quality' value='high' />"
      out += "<param name='height' value='#{height}' />"
      out += "<param name='width' value='#{width}' />"
      out += "<param name='menu' value='false' />"
      out += "<param name='FlashVars' value='xmlFilePath=#{gallery.xml_file_name}' />"
      out += "<embed src='#{gallery.swf.url}' quality='high' pluginspage='http://www.adobe.com/shockwave/download/download.cgi?P1_Prod_Version=ShockwaveFlash' type='application/x-shockwave-flash' width='#{width}' height='#{height}' menu='false' FlashVars='xmlFilePath=#{gallery.xml_file_name}'></embed>"
      out += "</object>"
    else
      raise TagError, "'gallery' tag must contain a valid 'name' attribute as well as 'height' and 'width' attributes."
    end
  end
end
