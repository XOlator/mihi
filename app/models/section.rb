class Section < ActiveRecord::Base

  include Activatable
  extend FriendlyId


  # ---------------------------------------------------------------------------

  friendly_id :slug_title, use: [:slugged]


  # ---------------------------------------------------------------------------

  has_many :exhibition_pieces
  has_many :pieces, through: :exhibition_pieces, source: :piece


  # ---------------------------------------------------------------------------

  validates :title,         presence: true, length: 2..255
  validates :subtitle,      presence: true, length: 2..255
  validates :excerpt,       presence: true, length: 2..255
  validates :description,   presence: true, length: 2..5000


  # ---------------------------------------------------------------------------

  default_scope { where(active: true).order('sort_index ASC') }


  def to_api
    {id: id, title: title, subtitle: subtitle, excerpt: excerpt, description: description, exhibition_pieces: self.exhibition_pieces.map(&:id)}
  end


private

  def slug_title
    return slug unless slug.blank?
    s = title.strip rescue SecureRandom.hex(4)
    s << "-#{SecureRandom.hex(1)}" if s.match(/^[0-9]+$/)
  end

end
