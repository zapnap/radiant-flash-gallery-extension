module Admin::GalleryItemsHelper
  def form_for_gallery_item(gallery_item, html_options = {}, &block)
    url = gallery_item.new_record? ?  admin_gallery_items_url(gallery_item.gallery) : admin_gallery_item_url(gallery_item.gallery, gallery_item)
    html_options[:multipart] = true
    html_options[:method] = :put unless gallery_item.new_record?
    form_for(:gallery_item, @gallery_item, :url => url, :html => html_options, &block)
  end

  # treats swf files as a special case; otherwise assumes asset is an image
  def gallery_item_asset_tag(asset, options = {})
    if asset.url.match(/^.*\.swf?(\?\d*)$/)
      link_to('Flash Content [preview]', asset.url, options.merge(:target => '_blank'))
    else
      image_tag(asset.url, options)
    end
  end
end
