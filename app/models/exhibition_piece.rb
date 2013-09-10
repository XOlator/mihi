class ExhibitionPiece < ActiveRecord::Base

  include Activatable


  # ---------------------------------------------------------------------------

  belongs_to :exhibition
  belongs_to :section
  belongs_to :piece, polymorphic: true


  # ---------------------------------------------------------------------------

  default_scope { where(active: true) }


  # ---------------------------------------------------------------------------

  # "Paginate"
  def next; self.class.where('exhibition_id = ? AND section_sort_index >= ? AND sort_index >= ? AND id > ?', self.exhibition_id, self.section_sort_index, self.sort_index, self.id).first; end
  def prev; self.class.where('exhibition_id = ? AND section_sort_index <= ? AND sort_index <= ? AND id < ?', self.exhibition_id, self.section_sort_index, self.sort_index, self.id).last; end


private


end
