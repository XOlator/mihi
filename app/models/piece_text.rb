class PieceText < ActiveRecord::Base

  include Pieceable
  include Activatable
  extend FriendlyId


  # ---------------------------------------------------------------------------

  THEMES = [:default]

  friendly_id :title, use: [:slugged]


  # ---------------------------------------------------------------------------

  belongs_to :exhibition_piece
  has_one :exhibition, through: :exhibition_piece
  has_one :piece_thumbnail


  # ---------------------------------------------------------------------------

  validates :title,         presence: true, length: 2..255
  validates :content,       presence: true, length: 2..5000
  validates :theme,         inclusion: {in: THEMES.map(&:to_s)}


  # ---------------------------------------------------------------------------

  default_scope { where(active: true) }


  # ---------------------------------------------------------------------------

  def to_api(*opts)
    opts = opts.extract_options!

    {id: id, slug: slug, title: title, content: content}
  end


private


end
