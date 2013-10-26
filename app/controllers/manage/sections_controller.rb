class Manage::SectionsController < ApplicationController

  before_filter :get_exhibition
  before_filter :prevent_if_locked
  before_filter :get_section, only: [:show, :edit, :update, :destroy]


  def show
    render :show
  end

  def new
    @section = @exhibition.sections.build
  end

  def create
    @section = @exhibition.sections.build(section_params)

    if @section.save
      redirect_to edit_manage_exhibition_section_url(@exhibition, @section)
    else
      flash.now[:error] = 'Error'
      render :new
    end
  end

  def edit
    render :edit
  end

  def update
    @section.assign_attributes(section_params)

    if @section.save
      redirect_to edit_manage_exhibition_section_url(@exhibition, @section)
    else
      flash.now[:error] = 'Error'
      render :edit
    end
  end

  def destroy
    if @section.destroy
      flash.now[:success] = 'Deleted'
    else
      flash.now[:error] = 'Error'
    end

    redirect_to edit_manage_exhibition_url(@exhibition)
  end


protected

  def get_exhibition
    @exhibition = Exhibition.friendly.find(params[:exhibition_id])
    raise ActiveRecord::RecordNotFound if @exhibition.blank?
  end

  def get_section
    @section = @exhibition.sections.friendly.find(params[:id])
    raise ActiveRecord::RecordNotFound if @section.blank?
  end

  def prevent_if_locked
    raise ActiveRecord::RecordNotFoud if @exhibition.locked?
  end

  def section_params
    params.require(:section).permit(:title, :subtitle, :excerpt, :description)
  end

end
