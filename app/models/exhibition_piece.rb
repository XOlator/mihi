class ExhibitionPiece < ActiveRecord::Base

  include Activatable


  # ---------------------------------------------------------------------------

  belongs_to :exhibition
  belongs_to :section
  belongs_to :piece, polymorphic: true


  # ---------------------------------------------------------------------------

  default_scope { where(active: true).order('section_sort_index ASC, sort_index ASC') }


  # ---------------------------------------------------------------------------



private


end
