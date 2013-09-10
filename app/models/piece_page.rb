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
      status = Timeout::timeout(TIMEOUT_LENGTH) do
        io = open(self.url, read_timeout: TIMEOUT_LENGTH, "User-Agent" => MIHI_USER_AGENT, allow_redirections: :all)
        io.class_eval { attr_accessor :original_filename }
        io.original_filename = [File.basename(self.filename), "html"].join('.')
        self.cache_page = io
        raise "Invalid content-type" unless io.content_type.match(/text\/html/i)
      end
    rescue OpenURI::HTTPError => err
      self.cache_page = nil
    rescue Timeout::Error => err
      puts "Fetch Page Error (Timeout): #{err}"
    rescue => err
      puts "Fetch Page Error (Error): #{err}"
    ensure
      # self.save
    end
  end


private


end
