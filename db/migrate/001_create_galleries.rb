class CreateGalleries < ActiveRecord::Migration
  def self.up
    create_table :galleries do |t|
      t.string   :title
      t.string   :description
      t.string   :xml_file_name
      t.string   :swf_file_name
      t.string   :swf_content_type
      t.integer  :swf_file_size
      t.datetime :swf_updated_at
      t.timestamps
    end

    create_table :gallery_items do |t|
      t.integer  :gallery_id
      t.string   :title
      t.string   :caption
      t.string   :link
      t.string   :asset_file_name
      t.string   :asset_content_type
      t.integer  :asset_file_size
      t.datetime :asset_updated_at
      t.timestamps
    end
  end

  def self.down
    drop_table :gallery_items
    drop_table :galleries
  end
end
