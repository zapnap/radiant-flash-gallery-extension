require File.dirname(__FILE__) + '/../../spec_helper'

describe Admin::GalleryItemsController do
  scenario :users

  before(:each) do
    login_as :existing
    @gallery = mock_model(Gallery, :to_param => 1, :gallery_items => [])
    Gallery.stub!(:find).and_return(@gallery)
  end

  context 'index' do
    before(:each) do
      @gallery.gallery_items.stub!(:find).and_return(@gallery_items = [mock_model(GalleryItem)])
    end

    it 'should render the index template' do
      get 'index', :gallery_id => 1
      response.should be_success
      response.should render_template('index')
    end
  end

  context 'new' do
    it 'should render the edit template' do
      @gallery.gallery_items.stub!(:build).and_return(@gallery_item = mock_model(GalleryItem))
      get 'new', :gallery_id => 1
      response.should be_success
      response.should render_template('edit')
    end
  end

  context 'create' do
    before(:each) do
      @gallery.gallery_items.stub!(:build).and_return(@gallery_item = mock_model(GalleryItem))
    end

    it 'should create a new gallery item and redirect' do
      @gallery_item.should_receive(:save).and_return(true)
      post 'create', :gallery_id => 1, :gallery_item => { :title => 'new name' }
      response.should be_redirect
      response.should redirect_to(admin_gallery_items_path(@gallery))
    end

    it 'should re-render the edit template if save fails' do
      @gallery_item.should_receive(:save).and_return(false)
      post 'create', :gallery_id => 1, :gallery_item => { :title => 'new name' }
      response.should be_success
      response.should render_template('edit')
      flash[:error].should_not be_nil
    end
  end

  context 'edit' do
    before(:each) do
      @gallery.gallery_items.stub!(:find).and_return(@gallery_item = mock_model(GalleryItem))
    end

    it 'should render the edit template' do
      get 'edit', :gallery_id => 1, :id => 1
      response.should be_success
      response.should render_template('edit')
    end
  end

  context 'update' do
    before(:each) do
      @gallery.gallery_items.stub!(:find).and_return(@gallery_item = mock_model(GalleryItem))
    end

    it 'should update the program and redirect' do
      @gallery_item.should_receive(:update_attributes).and_return(true)
      put 'update', :gallery_id => 1, :id => 1, :gallery_item => { :title => 'new name' }
      response.should be_redirect
      response.should redirect_to(admin_gallery_items_path(@gallery))
    end

    it 'should re-render the edit template if update fails' do
      @gallery_item.should_receive(:update_attributes).and_return(false)
      put 'update', :gallery_id => 1, :id => 1, :gallery_item => { :title => 'new name' }
      response.should be_success
      response.should render_template('edit')
      flash[:error].should_not be_nil
    end
  end

  context 'destroy' do
    before(:each) do 
      @gallery.gallery_items.stub!(:find).and_return(@gallery_item = mock_model(GalleryItem))
    end

    it 'should destroy the program and redirect' do
      @gallery_item.should_receive(:destroy).and_return(true)
      delete 'destroy', :gallery_id => 1, :id => 1
      response.should be_redirect
      response.should redirect_to(admin_gallery_items_path(@gallery))
    end
  end

  context 'positions' do
    before(:each) do
      @gallery.gallery_items.stub!(:find).and_return(@gallery_item = mock_model(GalleryItem))
    end

    %w{move_to_top move_higher move_lower move_to_bottom}.each do |action|
      it "should #{action.humanize} and redirect" do
        @gallery_item.should_receive(action)
        post action, :gallery_id => 1, :id => 1
        response.should be_redirect
        response.should redirect_to(admin_gallery_items_path(@gallery))
      end
    end
  end
end
