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
      format.json {
        results.call
        obj = {
          exhibition:     @exhibition.to_api(pieces: true),
          previous_piece: (!@prev_piece.blank? ? @prev_piece.id : nil),
          next_piece:     (!@next_piece.blank? ? @next_piece.id : nil)
        }

        render json: obj.to_json, callback: params[:callback]
      }
    end
  end


protected

  def get_exhibition
    @exhibition = Exhibition.friendly.find(params[:id])
    raise ActiveRecord::RecordNotFound if @exhibition.blank?
  end

end
