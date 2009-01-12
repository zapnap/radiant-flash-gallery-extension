class Admin::GalleryItemsController < ApplicationController
  before_filter :set_gallery

  def index
    @gallery_items = @gallery.gallery_items.find(:all, :order => 'position, created_at')
    render(:action => 'index')
  end

  def new
    @gallery_item = @gallery.gallery_items.build
    render(:action => 'edit')
  end

  def create
    @gallery_item = @gallery.gallery_items.build(params[:gallery_item])
    if @gallery_item.save
      flash[:notice] = "Successfully added a new gallery item."
      redirect_to(admin_gallery_items_path(@gallery))
    else
      flash[:error] = "Validation errors occurred while processing this form. Please take a moment to review the form and correct any input errors before continuing."
      render(:action => 'edit')
    end
  end

  def edit
    @gallery_item = @gallery.gallery_items.find(params[:id])
    render(:action => 'edit')
  end

  def update
    @gallery_item = @gallery.gallery_items.find(params[:id])
    if @gallery_item.update_attributes(params[:gallery_item])
      flash[:notice] = "Successfully updated the gallery item details."
      redirect_to(admin_gallery_items_path(@gallery))
    else
      flash[:error] = "Validation errors occurred while processing this form. Please take a moment to review the form and correct any input errors before continuing."
      render(:action => 'edit')
    end
  end

  def destroy
    @gallery_item = @gallery.gallery_items.find(params[:id])
    @gallery_item.destroy
    flash[:error] = "The gallery item was deleted."
    redirect_to(admin_gallery_items_path)
  end

  %w{move_to_top move_higher move_lower move_to_bottom}.each do |action|
    define_method action do
      @gallery_item = @gallery.gallery_items.find(params[:id])
      @gallery_item.send(action)
      redirect_to(admin_gallery_items_path)
    end
  end
  
  private

  def set_gallery
    @gallery = Gallery.find(params[:gallery_id])
  end
end
