class PiecePage < ActiveRecord::Base

  include Activatable


  # ---------------------------------------------------------------------------

  TIMEOUT_LENGTH = 10

  has_attached_file :cache_page


  # ---------------------------------------------------------------------------

  has_one :exhibition_piece
  has_one :exhibition, through: :exhibition_piece
  has_one :piece_thumbnail

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


  def cache_page_content
    begin
      uri = Addressable::URI.parse(self.url)
      status = Timeout::timeout(TIMEOUT_LENGTH) do
        io = open(self.url, read_timeout: TIMEOUT_LENGTH, "User-Agent" => MIHI_USER_AGENT, allow_redirections: :all)
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

  def read_cache_page
    return false if self.cache_page_file_size.to_i < 1

    begin
      status = Timeout::timeout(TIMEOUT_LENGTH) do
        open(self.url, read_timeout: TIMEOUT_LENGTH, "User-Agent" => MIHI_USER_AGENT, allow_redirections: :all).read
      end
    rescue OpenURI::HTTPError => err
      false
    rescue Timeout::Error => err
      false
    rescue => err
      false
    end
  end


private


end
