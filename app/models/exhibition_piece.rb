class ExhibitionPiece < ActiveRecord::Base

  include Rails.application.routes.url_helpers

  include Activatable
  extend FriendlyId

  TYPES = [:text, :page]


  # ---------------------------------------------------------------------------

  friendly_id :slug_title, use: [:slugged]


  # ---------------------------------------------------------------------------

  belongs_to :exhibition
  belongs_to :section
  belongs_to :piece, polymorphic: true
  # belongs_to :piece_text, class_name: 'PieceText', foreign_key: :piece_id
  # belongs_to :piece_page, class_name: 'PiecePage', foreign_key: :piece_id

  accepts_nested_attributes_for :piece


  # ---------------------------------------------------------------------------

  before_create :generate_uuid
  after_save :update_slug


  # ---------------------------------------------------------------------------

  default_scope { where(active: true) }


  # ---------------------------------------------------------------------------

  def to_api(*opts)
    opts = opts.extract_options!
    o = {id: id, slug: slug, uuid: uuid, type: type, title: title, urls: {canonical: browse_exhibition_piece_url(exhibition, self), short: exhibition_piece_short_url(uuid)}}
    o.merge!({piece: piece.to_api}) if piece.present? && piece.respond_to?(:to_api)
    o
  end

  def title; piece ? (piece.title || piece.slug) : ''; end
  def slug_title; (piece ? (piece.slug || piece.title) : '') rescue "".random(10); end
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

  def generate_uuid
    if self.uuid.blank?
      while true
        self.uuid = SecureRandom.hex(5)
        break unless ExhibitionPiece.where(uuid: self.uuid).count > 0
      end
    end
  end

end
