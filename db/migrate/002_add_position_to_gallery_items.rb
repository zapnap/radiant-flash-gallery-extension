class AddPositionToGalleryItems < ActiveRecord::Migration
  def self.up
    add_column :gallery_items, :position, :integer

    say_with_time("Putting all gallery items in a default order...") do
      Gallery.find(:all).each do |gallery|
        position = 1
        gallery.gallery_items.find(:all, :order => 'created_at').each do |item|
          item.update_attribute(:position, position)
          position += 1
        end
      end
    end
  end

  def self.down
    remove_column :gallery_items, :position
  end
end
