class StaticPagesController < ApplicationController

  before_filter :get_page, only: [:show]


  def show
    respond_to do |format|
      format.html {
        send(@page.page) rescue nil if respond_to?(@page.page)

        # @body_classes << 'static_page'
        # @body_classes << "page_#{@page.page.gsub(/\/|\-/m, '_').gsub(/("|')/m, '')}"

        render @page.file#, layout: (current_user? ? 'master' : 'intro')
      }
      format.any { render_not_found }
    end
  end

  # --- Page-specific Methods ---

  def home
    @exhibitions = Exhibition.limit(3).order('created_at desc')
  end


protected

  def get_page
    @page = StaticPage.new(params)
    raise ActiveRecord::RecordNotFound unless @page.exists?
  end

end
