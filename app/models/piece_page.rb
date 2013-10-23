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
      urls: {original: url, wayback: wayback_url, cached: cache_browse_exhibition_piece_url(self.exhibition, self.exhibition_piece)}, 
      title: title, excerpt: excerpt, description: description, author: author, organization: organization, 
      year: timeline_year, date: timeline_date,
      options: {
        glass: option_glass, clickable: option_clickable
      },
      events: page_events.map{|e| e.to_api}
    }
    o
  end

  def has_wayback_url?; !self.wayback_url.blank?; end
  def uri; @uri ||= URI.parse(self.url); end
  def uri_host; @uri_host ||= "#{uri.scheme}://#{uri.host}"; end
  def uri_host_path; @uri_host_path ||= (uri_host + "/#{uri.path.match(/\/$/) ? uri.path : File.dirname(uri.path)}/".gsub(/\/{2,}/m, '/')); end
  def wayback_uri; @wayback_uri ||= URI.parse(self.wayback_url); end
  def wayback_uri_host; @wayback_uri_host ||= "#{wayback_uri.scheme}://#{wayback_uri.host}"; end
  def wayback_uri_host_path; @wayback_uri_host_path ||= (wayback_uri_host + "/#{wayback_uri.path.match(/\/$/) ? wayback_uri.path : File.dirname(wayback_uri.path)}/".gsub(/\/{2,}/m, '/')); end


  def cache_page_content
    u = (has_wayback_url? ? wayback_uri : uri)
    uh = (has_wayback_url? ? wayback_uri_host : uri_host)
    up = (has_wayback_url? ? wayback_uri_host_path : uri_host_path)

    begin
      Timeout::timeout(TIMEOUT_LENGTH) do
        io = open(u, read_timeout: TIMEOUT_LENGTH, "User-Agent" => MIHI_USER_AGENT, allow_redirections: :all)
        raise "Invalid content-type" unless io.content_type.match(/text\/html/i)

        doc = Nokogiri::HTML.parse(io.read, u.to_s)
        doc.encoding = 'utf-8'

        # MIHI Dated Watermark
        doc.css("head").before(self.watermark)

        # Absoluteize links and assets
        %w(href src).each do |k|
          doc.css("*[#{k}]").each do |a|
            next if a.attributes[k].value.match(/^([A-Z]+\:)/i)
            a.attributes[k].value = (a.attributes[k].value.match(/^\//) ? uh : up) + a.attributes[k].value
          end
        end

        tempfile = Tempfile.new(u.host)
        tempfile.write(doc.to_html(:encoding => 'UTF-8'))
        tempfile.class_eval { attr_accessor :original_filename }
        tempfile.original_filename = [uri.host, File.basename(uri.path), "html"].reject{|v| v.blank? || v == '/'}.join('.').gsub(/\//, '')

        self.cache_page = tempfile
      end
    rescue OpenURI::HTTPError => err
      puts "Fetch Page Error (OpenURI): #{err}: #{u.to_s}"
    rescue Timeout::Error => err
      puts "Fetch Page Error (Timeout): #{err}: #{u.to_s}"
    rescue => err
      puts "Fetch Page Error (Error): #{err}: #{u.to_s}"
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
        open((cache_page.url.match(/^http/i) ? cache_page.url : cache_page.path), read_timeout: TIMEOUT_LENGTH, "User-Agent" => MIHI_USER_AGENT, allow_redirections: :all).read
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


# protected

  def watermark
    n = 80

    info = [] << self.title << self.url.truncate(n, omission: '')

    etc = [] << ([] << self.author << self.organization).join(', ') << (self.timeline_date || self.timeline_year)
    etc << " " << "Accessed from Archive.org" << self.wayback_url.truncate(n, omission: '') if self.has_wayback_url?

    bottom = [] << "Archived by The MIHI crawler at #{Time.now.to_s(:db)}" << 'http://www.themihi.net :: info@themihi.net'


    str = <<-eos

<!--


   #{' ____ ____ ____ _________ ____ ____ ____ ____ '.center(n)}
   #{'||T |||H |||E |||       |||M |||I |||H |||I ||'.center(n)}
   #{'||__|||__|||__|||_______|||__|||__|||__|||__||'.center(n)}
   #{'|/__\|/__\|/__\|/_______\|/__\|/__\|/__\|/__\|'.center(n)}

   #{'A r c h i v e d  W e b  P a g e'.upcase.center(n)}

   #{'_'*n}

   #{info.compact.map{|v| v.to_s.center(n)}.join("\n   ")}

   #{etc.compact.map{|v| v.to_s.center(n)}.join("\n   ")}
   #{'_'*n}

   #{bottom.compact.map{|v| v.to_s.center(n)}.join("\n   ")}


-->

    eos
  end

end
