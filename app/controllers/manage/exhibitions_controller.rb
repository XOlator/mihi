class Manage::ExhibitionsController < ApplicationController

  before_filter :get_exhibition, only: [:show, :edit, :update, :destroy]
  before_filter :prevent_if_locked, only: [:edit, :update, :destroy]

  layout 'manage'


  def show
    render :show
  end

  def new
    @exhibition = Exhibition.new
  end

  def create
    @exhibition = Exhibition.new(exhibition_params)

    if @exhibition.save
      redirect_to edit_manage_exhibition_url(@exhibition)
    else
      flash.now[:error] = 'Error'
      render :new
    end
  end

  def edit
    render :edit
  end

  def update
    @exhibition.assign_attributes(exhibition_params)

    if @exhibition.save
      redirect_to edit_manage_exhibition_url(@exhibition)
    else
      flash.now[:error] = 'Error'
      render :edit
    end
  end

  def destroy
    if @exhibition.destroy
      flash.now[:success] = 'Deleted'
    else
      flash.now[:error] = 'Error'
    end

    redirect_to root_url
  end


protected

  def get_exhibition
    @exhibition = Exhibition.friendly.find(params[:id])
    raise ActiveRecord::RecordNotFound if @exhibition.blank?
  end

  def prevent_if_locked
    raise ActiveRecord::RecordNotFoud if @exhibition.locked?
  end

  def exhibition_params
    params.require(:exhibition).permit(:title, :subtitle, :excerpt, :description, :theme, :publish_at, :unpublish_at, :option_glass, :option_playable, :option_wifi_restricted)
  end

end
