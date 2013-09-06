class Exhibition < ActiveRecord::Base

  include Activatable

  # ---------------------------------------------------------------------------

  THEMES = [:default]

  # friendly_id


  # ---------------------------------------------------------------------------

  has_many :sections
  has_many :exhibition_pieces
  has_many :pieces, through: :exhibition_pieces
  has_many :exhibition_users
  has_many :users, :through: :exhibition_users


  # ---------------------------------------------------------------------------

  default_scope where(active: true)


  # ---------------------------------------------------------------------------


private


end
