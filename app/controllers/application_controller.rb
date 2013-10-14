class ApplicationController < ActionController::Base

  protect_from_forgery with: :exception

  before_filter :app_init

  layout :layout_setup


  def app_init
    @meta_title, @meta_description, @meta_canonical_url, @meta_short_url, @meta_image = 'The MIHI', '', root_url, nil, nil
  end

  def layout_setup; 'main'; end


protected

  def notify_error_service(e)
    # Airbrake
    notify_airbrake(e)

    # Errplane
    # Errplane.transmit(e) rescue nil
  end

  def store_request_referrer
    session[:return_to] = request.referrer unless request.referrer.blank?
  end

  def store_request_referrer_by_request
    store_location(request.referrer) if !!params[:return]
  end

  def store_request_referrer_from_params
    unless params[:redirect].blank?
      store_location(params[:redirect])
    else
      session[:return_to] = nil
    end
  end

  # Ensure stored location is not an external page
  def store_location(url=nil)
    unless url.blank?
      uri = URI.parse(url) rescue nil
      return if uri.blank? || !uri.host.match(Regexp.new("#{Regexp.escape(Rails.application.routes.default_url_options[:host])}$", true))
    end
    session[:return_to] = url || request.fullpath
  end

  def redirect_back_or_default(default)
    redirect_to(session[:return_to] || default)
    session[:return_to] = nil
  end

  def setup_pagination(*opts)
    opts = {page: nil, per_page: 20}.merge(!opts[0].blank? ? opts[0] : {})
    opts[:page] ||= params[:page] unless params[:page].blank?
    opts[:page] = 1 if opts[:page].blank? || opts[:page].to_i < 1
    @_page, @_per_page = opts[:page], opts[:per_page]
  end


  # --- EXCEPTION HANDLING ----------------------------------------------------

  # Exception error handling
  def catch_exceptions
    yield
  rescue => exception
    raise exception if test? || dev?

    case exception
      when ActiveRecord::RecordNotFound
        render_not_found
      when Mihi::Unauthorized
        render_unauthorized
      when Mihi::ExpiredListing
        render_expired
      else
        notify_error_service(exception) rescue nil
        render_error
    end
  end

  # Render a 404 Not Found
  def render_not_found
    raise ActiveRecord::RecordNotFound if test? # TRACK AS RAISED ERROR
    render_error(status: 404, message: t('errors.not_found'))
  end

  # Render a 410 Expired Page
  def render_expired
    raise Mihi::ExpiredListing if test?
    render_error(status: 410, message: t('errors.expired'))
  end

  # Render a 403 Unauthorized
  def render_unauthorized
    raise Mihi::Unauthorized if test?
    render_error(status: 403, type: 'Unauthorized', message: t('errors.unauthorized'))
  end

  # Render desired error page (500 Server Error by default)
  def render_error(*opts)
    raise ActiveRecord::RecordNotFound if test?
    opts = opts.extract_options!
    opts[:message] ||= t("errors.error")
    opts[:status] = 500 unless [404,410,422,429,500].include?(opts[:status].to_i)

    respond_to do |format|
      format.html { render status: opts[:status], file: "public/#{opts[:file] || opts[:status]}.html", layout: false }
      format.json { render status: opts[:status], json: {error: true, type: opts[:type], reason: opts[:message]}.to_json, callback: params[:callback] }
      format.xml  { render status: opts[:status], xml: {error: true, type: opts[:type], reason: opts[:message]}.to_xml(dasherize: false, root: 'mihi') }
      format.any  { render status: opts[:status], nothing: true }
    end
  end


  def render_exhibition_page
    # Assume exhibition is loaded
    results = Proc.new {
      if @exhibition_piece.present?
        @prev_piece = @exhibition_piece.prev
        @next_piece = @exhibition_piece.next
      end

      @prev_piece ||= nil
      @next_piece ||= @exhibition.exhibition_pieces.first
    }

    respond_to do |format|
      format.html {
        @exhibition_piece ||= @exhibition.exhibition_pieces.first
        
        if @exhibition_piece.present?
          @meta_canonical_url = browse_exhibition_piece_url(@exhibition, @exhibition_piece)
          @meta_title = @exhibition_piece.title
          @meta_description = @exhibition_piece.piece.excerpt rescue nil
          @meta_short_url ||= exhibition_piece_short_url(@exhibition_piece.uuid)
          @meta_image ||= nil
        end

        @meta_canonical_url ||= browse_exhibition_url(@exhibition)
        @meta_title ||= @exhibition.title
        @meta_description ||= @exhibition.excerpt
        @meta_short_url ||= nil
        @meta_image ||= nil

        results.call
        render 'browse/exhibition_pieces/show'
      }
      format.json {
        results.call
        obj = {
          exhibition:     @exhibition.to_api(pieces: true, sections: true),
          current_piece:  (@exhibiton_piece.present? ? @exhibition_piece.id : nil),
          previous_piece: (!@prev_piece.blank? ? @prev_piece.id : nil),
          next_piece:     (!@next_piece.blank? ? @next_piece.id : nil)
        }

        render json: obj.to_json, callback: params[:callback]
      }
    end
  end

end
