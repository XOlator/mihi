class PieceText < ActiveRecord::Base

  include Activatable

  # ---------------------------------------------------------------------------


  has_one :exhibition_piece
  has_one :exhibition, through: :exhibition_piece
  has_one :piece_thumbnail


  # ---------------------------------------------------------------------------

  default_scope where(active: true)


  # ---------------------------------------------------------------------------


private


end
