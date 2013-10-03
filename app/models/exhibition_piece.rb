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

  def to_api(*opts)
    opts = opts.extract_options!
    o = {id: id, slug: slug, type: type}
    o.merge!({piece: piece.to_api}) if piece.present? && piece.respond_to?(:to_api)
    o
  end

  def title; piece.slug || piece.title rescue "".random(10); end
  def type; piece_type.gsub(/^piece/i, '') rescue nil; end

  # "Paginate"
  def next; self.class.where('exhibition_id = ? AND section_sort_index >= ? AND sort_index >= ? AND id > ?', exhibition_id, section_sort_index, sort_index, id).first; end
  def prev; self.class.where('exhibition_id = ? AND section_sort_index <= ? AND sort_index <= ? AND id < ?', exhibition_id, section_sort_index, sort_index, id).last; end


private

  def update_slug
    return if piece_id.blank?
    return if piece.slug == slug
    update_attribute(:slug, piece.slug)
  end

end
