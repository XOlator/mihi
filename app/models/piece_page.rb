class PiecePage < ActiveRecord::Base

  include Rails.application.routes.url_helpers

  include Nokogiri
  include Pieceable
  include Activatable
  extend FriendlyId


  # ---------------------------------------------------------------------------

  TIMEOUT_LENGTH = 10

  has_attached_file :cache_page

  friendly_id :title, use: [:slugged]


  # ---------------------------------------------------------------------------

  has_one :exhibition_piece, foreign_key: 'piece_id'
  has_one :exhibition, through: :exhibition_piece
  has_one :piece_thumbnail
  has_many :page_events, class_name: 'PiecePageEvent'
  has_many :piece_assets


  # ---------------------------------------------------------------------------

  before_create :cache_page_content


  # ---------------------------------------------------------------------------

  serialize :focus_position, Array
  serialize :focus_keywords, Array

  validates :url,           presence: true, url: true
  validates :title,         presence: true, length: 2..255
  validates :description,   presence: true, length: 2..2000
  validates :excerpt,       presence: true, length: 2..255
  validates :author,        presence: true, length: 2..255
  validates :organization,  presence: true, length: 2..255
  # validates :timeline_year, presence: true, inclusion: {:in => 1969..(Date.today.year+1)}
  # validates :timeline_year, presence: true, inclusion: {:in => 1969..(Date.today.year+1)}


  # ---------------------------------------------------------------------------

  default_scope { where(active: true) }


  # ---------------------------------------------------------------------------

  def to_api(*opts)
    opts = opts.extract_options!
    o = {
      id: id, 
      urls: {original: url, cached: cache_browse_exhibition_piece_url(self.exhibition, self.exhibition_piece)}, 
      title: title, excerpt: excerpt, description: description, author: author, organization: organization, 
      year: timeline_year, date: timeline_date,
      options: {
        glass: option_glass, clickable: option_clickable
      },
      events: page_events.map{|e| e.to_api}
    }

    o
  end

  def uri; @uri ||= URI.parse(self.url); @uri; end
  def uri_host; "#{uri.scheme}://#{uri.host}"; end
  def uri_host_path; "#{uri.scheme}://" << "#{uri.host}/#{File.dirname(uri.path)}/".gsub(/\/{2,}/m, '/'); end

  def cache_page_content
    begin
      uri = Addressable::URI.parse(self.url)
      Timeout::timeout(TIMEOUT_LENGTH) do
        io = open(uri, read_timeout: TIMEOUT_LENGTH, "User-Agent" => MIHI_USER_AGENT, allow_redirections: :all)
        raise "Invalid content-type" unless io.content_type.match(/text\/html/i)
        io.class_eval { attr_accessor :original_filename }
        io.original_filename = [uri.host, File.basename(uri.path), "html"].reject{|v| v.blank? || v == '/'}.join('.').gsub(/\//, '')
        self.cache_page = io
      end
    rescue OpenURI::HTTPError => err
      puts "Fetch Page Error (OpenURI): #{err}"
    rescue Timeout::Error => err
      puts "Fetch Page Error (Timeout): #{err}"
    rescue => err
      puts "Fetch Page Error (Error): #{err}"
    end
  end
  # TODO : MAKE delayed_queue


  # TODO : Make more robust
  # ---------------------------------------------------------------------------
  # Page should store a cached HTML file. It should store the HTML file and set a <base> tag if one is not set
  # There should then be a cache system that fetches files not found and displays them. Full asset cache eventually
  # Should also do some stripping of google analytics, etc.
  # Should track its own page views.

  def read_cache_page
    return false if cache_page_file_size.to_i < 1

    begin
      Timeout::timeout(TIMEOUT_LENGTH) do
        html = open(url, read_timeout: TIMEOUT_LENGTH, "User-Agent" => MIHI_USER_AGENT, allow_redirections: :all).read
        html.force_encoding "UTF-8"
        doc = Nokogiri::HTML.parse(html)

        # Links and assets
        %w(href src).each do |k|
          doc.css("*[#{k}]").each do |a|
            next if a.attributes[k].value.match(/^([A-Z]+\:)/i)
            a.attributes[k].value = (a.attributes[k].value.match(/^\//) ? uri_host : uri_host_path) + a.attributes[k].value
          end
        end

        doc.to_s
      end
    rescue OpenURI::HTTPError => err
      false
    rescue Timeout::Error => err
      false
    rescue => err
      puts "ERR: #{err}"
      false
    end
  end


private


end
