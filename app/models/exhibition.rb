class Exhibition < ActiveRecord::Base

  include Rails.application.routes.url_helpers

  include Activatable
  extend FriendlyId


  # ---------------------------------------------------------------------------

  THEMES = [:default]

  friendly_id :title, use: [:slugged]


  # ---------------------------------------------------------------------------

  has_many :sections
  has_many :exhibition_pieces
  has_many :pieces, through: :exhibition_pieces
  has_many :exhibition_users
  has_many :users, through: :exhibition_users


  # ---------------------------------------------------------------------------

  before_validation :ensure_theme


  # ---------------------------------------------------------------------------

  validates :title,         presence: true,  length: 2..255
  validates :subtitle,      presence: true,  length: 2..255
  validates :description,   presence: true,  length: 2..2000
  validates :excerpt,       presence: true,  length: 2..255
  validates :theme,         inclusion: {in: THEMES.map(&:to_s)}


  # ---------------------------------------------------------------------------

  default_scope { where(active: true) }


  # ---------------------------------------------------------------------------

  def to_api(*opts)
    opts = opts.extract_options!

    o = {id: id, slug: slug, title: title, subtitle: subtitle, excerpt: excerpt, description: description, urls: {canonical: browse_exhibition_url(self)}}

    if opts[:sections]
      o[:sections] = {}
      self.sections.each{|s| o[:sections][s.id] = s.to_api}
    end

    if opts[:pieces]
      o[:pieces] = {}
      self.exhibition_pieces.each{|e| o[:pieces][e.id] = e.to_api}
    end
    o
  end



private

  def ensure_theme
    self.theme ||= THEMES.first
  end



end
