class GalleryItem < ActiveRecord::Base
  belongs_to :gallery
  has_attached_file :asset

  validates_presence_of :gallery
  validates_attachment_presence :asset
  #validates_attachment_content_type :asset, :content_type => ['image/jpeg', 'image/png', 'image/gif', 'image/jpg']

  after_save :publish
  after_destroy :publish

  private

  def publish
    gallery.publish
  end
end
