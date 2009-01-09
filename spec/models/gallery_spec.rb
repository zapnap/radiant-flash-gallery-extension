require File.dirname(__FILE__) + '/../spec_helper'

describe Gallery do
  before(:each) do
    @gallery = Gallery.new(valid_attributes)
    @xml_location = "#{FlashGalleryExtension::GALLERY_PATH}/happy_fun_gallery.xml"
    @swf_location = "#{FlashGalleryExtension::GALLERY_PATH}/#{FlashGalleryExtension::DEFAULT_SWF}"
  end

  it "should be valid" do
    @gallery.should be_valid
  end

  context "validations" do
    it "should require a title" do
      @gallery.title = nil
      @gallery.should_not be_valid
      @gallery.errors.on(:title).should == "can't be blank"
    end

    it "should require a unique title" do
      @gallery.save
      @gallery = Gallery.new(valid_attributes)
      @gallery.should_not be_valid
      @gallery.errors.on(:title).should == "has already been taken"
    end
  end

  it "should generate a slugged file name" do
    @gallery.save
    @gallery.xml_file_name.should == @xml_location
  end
  
  it "should set a default swf file name" do
    @gallery.save
    @gallery.swf_file_name.should == @swf_location
  end

  context "xml output" do
    before(:each) do
      File.delete("#{RAILS_ROOT}/public#{@xml_location}") if File.exists?("#{RAILS_ROOT}/public#{@xml_location}")
      @gallery.save
    end

    it "should include gallery and album tags" do
      @gallery.to_xml.should have_tag('gallery') do
        with_tag("album[title=#{@gallery.title}]")
      end
    end

    it "should include gallery items" do
      item1 = item2 = mock('GalleryItem', :null_object => true)
      @gallery.stub!(:gallery_items).and_return([item1, item2])
      @gallery.to_xml.should have_tag('img', :count => 2)
    end

    it "should publish the xml" do
      @gallery.publish
      File.exists?("#{RAILS_ROOT}/public#{@xml_location}").should be_true
      File.read("#{RAILS_ROOT}/public#{@xml_location}").should == @gallery.to_xml
    end
  end

  private

  def valid_attributes
    { :title       => 'Happy Fun Gallery',
      :description => 'Fun!' }
  end
end
