class Exhibition < ActiveRecord::Base

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
  validates :theme,         inclusion: {in: THEMES}


  # ---------------------------------------------------------------------------

  default_scope { where(active: true) }


  # ---------------------------------------------------------------------------


private

  def ensure_theme
    self.theme ||= THEMES.first
  end



end
