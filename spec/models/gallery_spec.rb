require File.dirname(__FILE__) + '/../spec_helper'

SWF_TEST_FILE = File.dirname(__FILE__) + '/../files/test.swf'

describe Gallery do
  before(:each) do
    @gallery = Gallery.new(valid_attributes)
    @uploaded_file = ActionController::TestUploadedFile.new(SWF_TEST_FILE,'application/x-shockwave-flash')
    @gallery.swf = @uploaded_file

    @xml_location = "#{FlashGalleryExtension::GALLERY_PATH}/happy_fun_gallery.xml"
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

    it "should have a valid attachment" do
      @gallery.swf = nil
      @gallery.should_not be_valid
      @gallery.errors.on(:swf).should == "must be set."
    end

    it "should check content type of attachment" do
      @gallery.swf = ActionController::TestUploadedFile.new(SWF_TEST_FILE, 'application/pdf')
      @gallery.should_not be_valid
      @gallery.errors.on(:swf).should == "is not one of the allowed file types."
    end
  end

  it "should generate a slugged file name" do
    @gallery.save
    @gallery.xml_file_name.should == @xml_location
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
      @gallery.gallery_items.should_receive(:find).with(:all, :order => 'position, created_at').and_return([item1, item2])
      @gallery.to_xml.should have_tag('img', :count => 2)
    end

    it "should be published" do
      @gallery.publish
      File.exists?("#{RAILS_ROOT}/public#{@xml_location}").should be_true
      File.read("#{RAILS_ROOT}/public#{@xml_location}").should == @gallery.to_xml
    end

    it "should automatically be published after changes" do
      @gallery.should_receive(:publish).and_return(true)
      @gallery.save
    end

    it "should automatically be deleted after the model is destroyed" do
      @gallery.should_receive(:unpublish).and_return(true)
      @gallery.destroy
    end
  end

  private

  def valid_attributes
    { :title       => 'Happy Fun Gallery',
      :description => 'Fun!' }
  end
end
