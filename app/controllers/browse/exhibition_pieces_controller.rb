# encoding: UTF-8

class Browse::ExhibitionPiecesController < ApplicationController

  before_filter :get_exhibition, only: [:show, :cache]
  before_filter :get_exhibition_piece, only: [:show, :cache]
  before_filter :ensure_cacheable_piece, only: [:cache]
  before_filter :get_exhibition_piece_by_uuid, only: [:uuid_lookup]

  # page_cache :cache

  layout 'browse'


  # View the exhibition piece
  def show
    render_exhibition_page
  end

  # View the cached frame version of the exhibition piece.
  def cache
    case @exhibition_piece.piece.class.name
      when 'PiecePage'
        @content = @exhibition_piece.piece.read_cache_page
        @content ||= "<html>\n<head>\n<title>test</title>\n</head>\n<body>\n\n<h1>Offline: #{@exhibition_piece.piece.url}</h1>\n" << (0..100).map{|i| "<p>#{i}</p>"}.join("\n") << "\n\n</body>\n</html>\n"
        @content.encode!('UTF-8', 'UTF-8', invalid: :replace)
        redirect_to @exhibition_piece.piece.url and return if @content.blank?
    end

    render :cache, layout: nil
  end

  def uuid_lookup
    redirect_to browse_exhibition_piece_url(@exhibition_piece.exhibition, @exhibition_piece)
  end


protected

  def get_exhibition
    @exhibition = Exhibition.friendly.find(params[:exhibition_id])
    raise ActiveRecord::RecordNotFound if @exhibition.blank?
  end

  def get_exhibition_piece
    @exhibition_piece = @exhibition.exhibition_pieces.friendly.find(params[:id])
    raise ActiveRecord::RecordNotFound if @exhibition_piece.blank?
  end

  def get_exhibition_piece_by_uuid
    @exhibition_piece = ExhibitionPiece.find_by_uuid(params[:id])
    raise ActiveRecord::RecordNotFound if @exhibition_piece.blank? || @exhibition_piece.exhibition.blank?
  end

  def ensure_cacheable_piece
    raise ActiveRecord::RecordNotFound unless [PiecePage].include?(@exhibition_piece.piece.class)
  end

end
