class PiecePage < ActiveRecord::Base

  include Activatable

  # ---------------------------------------------------------------------------

  # PAPERCLIP :cache_page


  # ---------------------------------------------------------------------------

  has_one :exhibition_piece
  has_one :exhibition, through: :exhibition_piece
  has_one :piece_thumbnail

  has_many :piece_assets


  # ---------------------------------------------------------------------------

  serialize :focus_position, Array
  serialize :focus_keywords, Array


  # ---------------------------------------------------------------------------

  default_scope where(active: true)


  # ---------------------------------------------------------------------------


private


end
