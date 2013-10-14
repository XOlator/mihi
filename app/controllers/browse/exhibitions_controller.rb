class Browse::ExhibitionsController < ApplicationController

  before_filter :get_exhibition, only: [:show]

  layout 'browse'


  def show
    render_exhibition_page
  end


protected

  def get_exhibition
    @exhibition = Exhibition.friendly.find(params[:id])
    raise ActiveRecord::RecordNotFound if @exhibition.blank?
  end

end
