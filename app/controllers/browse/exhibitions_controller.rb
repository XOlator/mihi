class Browse::ExhibitionsController < ApplicationController

  before_filter :get_exhibition, only: [:show]

  layout 'browse'


  def show
    results = Proc.new {
      @prev_piece = nil
      @next_piece = @exhibition.exhibition_pieces.first
    }

    respond_to do |format|
      format.html {
        results.call
        render :show
      }
    end
  end


protected

  def get_exhibition
    @exhibition = Exhibition.find(params[:id])
    raise ActiveRecord::RecordNotFound if @exhibition.blank?
  end

end
