class Manage::ExhibitionPiecesController < ApplicationController

  before_filter :get_exhibition_and_section
  before_filter :prevent_if_locked
  before_filter :get_exhibition_piece, only: [:show, :edit, :update, :destroy]


  def show
    render :show
  end

  def new
    @exhibition_piece = @section.exhibition_pieces.build
    case params[:type]
      when 'text'; @exhibition_piece.piece = PieceText.new
      when 'page'; @exhibition_piece.piece = PiecePage.new
    end
  end

  def create
    @exhibition_piece = @section.exhibition_pieces.build
    case params[:type]
      when 'text'; @exhibition_piece.piece = PieceText.new
      when 'page'; @exhibition_piece.piece = PiecePage.new
    end
    @exhibition_piece.assign_attributes(piece_params)

    if @exhibition_piece.save
      redirect_to edit_manage_exhibition_section_piece_url(@exhibition, @section, @exhibition_piece)
    else
      flash.now[:error] = 'Error'
      render :new
    end
  end

  def edit
    render :edit
  end

  def update
    @exhibition_piece.assign_attributes(piece_params)

    if @exhibition_piece.save
      redirect_to edit_manage_exhibition_section_piece_url(@exhibition, @section, @exhibition_piece)
    else
      flash.now[:error] = 'Error'
      render :edit
    end
  end

  def destroy
    if @exhibition_piece.destroy
      flash.now[:success] = 'Deleted'
    else
      flash.now[:error] = 'Error'
    end

    redirect_to manage_exhibition_url(@exhibition)
  end


protected

  def get_exhibition_and_section
    @exhibition = Exhibition.friendly.find(params[:exhibition_id])
    raise ActiveRecord::RecordNotFound if @exhibition.blank?

    @section = @exhibition.sections.friendly.find(params[:section_id])
    raise ActiveRecord::RecordNotFound if @section.blank?
  end

  def get_exhibition_piece
    @exhibition_piece = @section.exhibition_pieces.friendly.find(params[:id])
    raise ActiveRecord::RecordNotFound if @exhibition_piece.blank?
  end

  def prevent_if_locked
    raise ActiveRecord::RecordNotFoud if @exhibition.locked?
  end

  def piece_params
    case params[:type] || @exhibition_piece.piece.class.to_s
      when 'text', 'PieceText'; attrs = [:theme, :title, :content]
      when 'page', 'PiecePage'; attrs = []
      else; attrs = []
    end
    params.require(:exhibition_piece).permit(piece_attributes: attrs)
  end

end
