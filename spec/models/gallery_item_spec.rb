require File.dirname(__FILE__) + '/../spec_helper'

TEST_FILE = RAILS_ROOT + '/public/images/admin/page.png'

describe GalleryItem do
  before(:each) do
    @gallery_item = GalleryItem.new(valid_attributes)
    @uploaded_file = ActionController::TestUploadedFile.new(TEST_FILE,'image/jpeg')
    @gallery_item.asset = @uploaded_file
  end

  it "should be valid" do
    @gallery_item.should be_valid
  end

  context "validations" do
    it "should require a gallery" do
      @gallery_item.gallery = nil
      @gallery_item.should_not be_valid
      @gallery_item.errors.on(:gallery).should == "can't be blank"
    end
  end

  it "should have a valid attachment" do
     @gallery_item.asset = nil
     @gallery_item.should_not be_valid
     @gallery_item.errors.on(:asset).should == "must be set."
  end

  #it "should check content type of attachment" do
  #  @gallery_item.asset = ActionController::TestUploadedFile.new(TEST_FILE, 'application/pdf')
  #  @gallery_item.should_not be_valid
  #  @gallery_item.errors.on(:asset).should == "is not one of the allowed file types."
  #end

  it "should republish the associated xml file after save" do
    @gallery_item.gallery.should_receive(:publish).and_return(true)
    @gallery_item.save
  end

  it "should republish the associated xml file after destroy" do
    @gallery_item.gallery.should_receive(:publish).and_return(true)
    @gallery_item.destroy
  end

  private

  def valid_attributes
    { :gallery => mock_model(Gallery, :id => 1),
      :title => 'photo of you',
      :caption => 'a photo of you' }
  end
end
