class Section < ActiveRecord::Base

  include Activatable


  # ---------------------------------------------------------------------------

  # friendly_id


  # ---------------------------------------------------------------------------

  has_many :exhibition_pieces
  has_many :pieces, through: :exhibition_pieces, source: :piece


  # ---------------------------------------------------------------------------

  validates :title,         presence: true, length: 2..255
  validates :subtitle,      presence: true, length: 2..255
  validates :excerpt,       presence: true, length: 2..255
  validates :description,   presence: true, length: 2..5000


  # ---------------------------------------------------------------------------

  default_scope { where(active: true).order('sort_index ASC') }



private


end
