class Section < ActiveRecord::Base

  include Activatable

  # ---------------------------------------------------------------------------

  has_many :exhibition_pieces
  has_many :pieces, through: :exhibition_pieces


  # ---------------------------------------------------------------------------


private


end
