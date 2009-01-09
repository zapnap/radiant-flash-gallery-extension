module FlashGalleryTags
  include Radiant::Taggable

  class TagError < StandardError; end

  desc %{
    Display a Flash gallery. You must specify the gallery name.

    *Usage:*
    <pre><code><r:gallery name="My Portfolio"/></code></pre>
  }
  tag 'gallery' do |tag|
    if tag.attr['name'] && gallery = Gallery.find_by_title(tag.attr['name'])
      out = "<object classid='clsid:D27CDB6E-AE6D-11cf-96B8-444553540000' codebase='http://download.macromedia.com/pub/shockwave/cabs/flash/swflash.cab#version=9,0,28,0'>"
      out += "<param name='movie' value='#{gallery.swf_file_name}' />"
      out += "<param name='quality' value='high' />"
      out += "<param name='menu' value='false' />"
      out += "<param name='FlashVars' value='xmlFilePath=#{gallery.xml_file_name}&xmlFileType=Default' />"
      out += "<embed src='#{gallery.swf_file_name}' quality='high' pluginspage='http://www.adobe.com/shockwave/download/download.cgi?P1_Prod_Version=ShockwaveFlash' type='application/x-shockwave-flash' menu='false' FlashVars='xmlFilePath=#{gallery.xml_file_name}&xmlFileType=Default'></embed>"
      out += "</object>"
    else
      raise TagError, "'gallery' tag must contain a valid 'name' attribute."
    end
  end
end
