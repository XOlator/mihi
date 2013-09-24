class PiecePageEvent < ActiveRecord::Base

  include Activatable


  TYPES = [:none, :scroll, :popup, :highlight]

  # ---------------------------------------------------------------------------

  belongs_to :piece_page


  # ---------------------------------------------------------------------------

  serialize :action_array, Array

  validates :action_type,     presence: true, inclusion: {:in => 0..TYPES.size}
  validates :action_array,    presence: true
  validates :action_text,   presence: true, length: 2..2000, if: Proc.new{|a| [:popup, :highlight].include?(TYPES[a.action_type]) }


  # ---------------------------------------------------------------------------

  default_scope { where(active: true).order('sort_index ASC') }


  # ---------------------------------------------------------------------------



private


end
