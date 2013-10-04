class Browse::ExhibitionPiecesController < ApplicationController

  before_filter :get_exhibition, only: [:show, :cache]
  before_filter :get_exhibition_piece, only: [:show, :cache]
  before_filter :ensure_cacheable_piece, only: [:cache]

  # page_cache :cache

  layout 'browse'


  # View the exhibition piece
  def show
    results = Proc.new {
      @prev_piece = @exhibition_piece.prev
      @next_piece = @exhibition_piece.next
    }

    respond_to do |format|
      format.html {
        results.call
        render :show
      }
      format.json {
        results.call
        obj = {
          piece:          @exhibition_piece.to_api,
          exhibition:     @exhibition.to_api,
          previous_piece: (!@prev_piece.blank? ? @prev_piece.id : nil),
          next_piece:     (!@next_piece.blank? ? @next_piece.id : nil)
        }
        
        render json: obj.to_json, callback: params[:callback]
      }
    end
  end

  # View the cached frame version of the exhibition piece.
  def cache
    case @exhibition_piece.piece.class.name
      when 'PiecePage'
        @content = @exhibition_piece.piece.read_cache_page
        @content ||= "<html>\n<head>\n<title>test</title>\n</head>\n<body>\n\n<h1>Offline: #{@exhibition_piece.piece.url}</h1>\n" << (0..100).map{|i| "<p>#{i}</p>"}.join("\n") << "\n\n</body>\n</html>\n"
        redirect_to @exhibition_piece.piece.url and return if @content.blank?
    end

    render :cache, layout: nil
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

  def ensure_cacheable_piece
    raise ActiveRecord::RecordNotFound unless [PiecePage].include?(@exhibition_piece.piece.class)
  end

end
