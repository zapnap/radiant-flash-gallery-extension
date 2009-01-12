class GalleryItem < ActiveRecord::Base
  belongs_to :gallery

  acts_as_list :scope => :gallery_id
  has_attached_file :asset

  validates_presence_of :gallery
  validates_attachment_presence :asset
  #validates_attachment_content_type :asset, :content_type => ['image/jpeg', 'image/png', 'image/gif', 'image/jpg']

  before_save :set_position
  after_save :publish
  after_destroy :publish

  private

  def set_position
    self.position = (GalleryItem.maximum(:position) || 0) + 1 if position.nil?
  end

  def publish
    gallery.publish
  end
end
