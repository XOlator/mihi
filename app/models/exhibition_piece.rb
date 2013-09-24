class ExhibitionPiece < ActiveRecord::Base

  include Activatable
  extend FriendlyId


  # ---------------------------------------------------------------------------

  friendly_id :title, use: [:slugged]


  # ---------------------------------------------------------------------------

  belongs_to :exhibition
  belongs_to :section
  belongs_to :piece, polymorphic: true
  # belongs_to :piece_text, class_name: 'PieceText', foreign_key: :piece_id
  # belongs_to :piece_page, class_name: 'PiecePage', foreign_key: :piece_id


  # ---------------------------------------------------------------------------

  after_save :update_slug


  # ---------------------------------------------------------------------------

  default_scope { where(active: true) }


  # ---------------------------------------------------------------------------

  def title; self.piece.slug || self.piece.title rescue "".random(10); end

  # "Paginate"
  def next; self.class.where('exhibition_id = ? AND section_sort_index >= ? AND sort_index >= ? AND id > ?', self.exhibition_id, self.section_sort_index, self.sort_index, self.id).first; end
  def prev; self.class.where('exhibition_id = ? AND section_sort_index <= ? AND sort_index <= ? AND id < ?', self.exhibition_id, self.section_sort_index, self.sort_index, self.id).last; end


private

  def update_slug
    return if self.piece_id.blank?
    return if self.piece.slug == self.slug
    puts self.piece.slug rescue "no slug"
    self.update_attribute(:slug, self.piece.slug)
  end

end
