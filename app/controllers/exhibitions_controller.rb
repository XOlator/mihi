class ExhibitionsController < ApplicationController

  before_filter :get_exhibition, only: [:show]


  def index
    results = Proc.new {
      @exhibitions = Exhibition.all
    }

    respond_to do |format|
      format.html {
        results.call
        render :index
      }
    end
  end

  def show
    results = Proc.new {
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
    @exhibition = Exhibition.friendly.find(params[:id])
    raise ActiveRecord::RecordNotFound if @exhibition.blank?
  end

end
