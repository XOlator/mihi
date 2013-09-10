class PieceText < ActiveRecord::Base

  include Activatable


  # ---------------------------------------------------------------------------

  THEMES = [:default]


  # ---------------------------------------------------------------------------

  has_one :exhibition_piece
  has_one :exhibition, through: :exhibition_piece
  has_one :piece_thumbnail


  # ---------------------------------------------------------------------------

  validates :title,         presence: true, length: 2..255
  validates :content,       presence: true, length: 2..5000
  validates :theme,         inclusion: {in: THEMES}


  # ---------------------------------------------------------------------------

  default_scope { where(active: true) }


  # ---------------------------------------------------------------------------


private


end
