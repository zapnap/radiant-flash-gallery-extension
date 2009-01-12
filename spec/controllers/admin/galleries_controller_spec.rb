require File.dirname(__FILE__) + '/../../spec_helper'

describe Admin::GalleriesController do
  scenario :users

  before(:each) do
    login_as :existing
  end

  context 'index' do
    before(:each) do
      Gallery.stub!(:find).and_return(@galleries = [mock_model(Gallery)])
    end

    it 'should render the index template' do
      get 'index'
      response.should be_success
      response.should render_template('index')
    end
  end

  context 'new' do
    it 'should render the edit template' do
      get 'new'
      response.should be_success
      response.should render_template('edit')
    end
  end

  context 'create' do
    before(:each) do
      Gallery.stub!(:new).and_return(@gallery = mock_model(Gallery))
    end

    it 'should create a new gallery and redirect' do
      @gallery.should_receive(:save).and_return(true)
      post 'create', :gallery => { :title => 'new name' }
      response.should be_redirect
      response.should redirect_to(admin_galleries_path)
    end

    it 'should re-render the edit template if save fails' do
      @gallery.should_receive(:save).and_return(false)
      post 'create', :gallery => { :title => 'new name' }
      response.should be_success
      response.should render_template('edit')
      flash[:error].should_not be_nil
    end
  end

  context 'show' do # preview
    integrate_views

    before(:each) do
      Page.stub!(:new).and_return(@page = mock_model(Page, :null_object => true))
      Gallery.stub!(:find).and_return(@gallery = mock_model(Gallery, :title => 'title'))
    end

    it 'should render the preview template' do
      get 'show', :id => 1
      response.should be_success
      response.should render_template('preview')
    end

    it 'should render the tag to preview gallery output' do
      @page.should_receive(:send).with(:parse, anything()).and_return("<div id='flash'></div>")
      get 'show', :id => 1
      response.should have_tag('div#flash')
    end
  end

  context 'edit' do
    before(:each) do
      Gallery.stub!(:find).and_return(@gallery = mock_model(Gallery))
    end

    it 'should render the edit template' do
      get 'edit', :id => 1
      response.should be_success
      response.should render_template('edit')
    end
  end

  context 'update' do
    before(:each) do
      Gallery.stub!(:find).and_return(@gallery = mock_model(Gallery))
    end

    it 'should update the program and redirect' do
      @gallery.should_receive(:update_attributes).and_return(true)
      put 'update', :id => 1, :gallery => { :title => 'new name' }
      response.should be_redirect
      response.should redirect_to(admin_galleries_path)
    end

    it 'should re-render the edit template if update fails' do
      @gallery.should_receive(:update_attributes).and_return(false)
      put 'update', :id => 1, :gallery => { :title => 'new name' }
      response.should be_success
      response.should render_template('edit')
      flash[:error].should_not be_nil
    end
  end

  context 'destroy' do
    before(:each) do 
      Gallery.stub!(:find).and_return(@gallery = mock_model(Gallery))
    end

    it 'should destroy the program and redirect' do
      @gallery.should_receive(:destroy).and_return(true)
      delete 'destroy', :id => 1
      response.should be_redirect
      response.should redirect_to(admin_galleries_path)
    end
  end

  context 'publish' do
    before(:each) do
      Gallery.stub!(:find).with(:all).and_return(@galleries = [@gallery = mock_model(Gallery)])
    end

    it 'should generate new xml for each gallery and redirect' do
      @gallery.should_receive(:publish).and_return(true)
      post 'publish' # collection
      response.should be_redirect
      response.should redirect_to(admin_galleries_path)
    end
  end
end
