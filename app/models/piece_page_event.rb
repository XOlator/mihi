class PiecePageEvent < ActiveRecord::Base

  include Activatable


  TYPES = [:none, :scroll, :scroll_to_element, :popup, :highlight, :click, :clickthrough]

  # ---------------------------------------------------------------------------

  belongs_to :piece_page


  # ---------------------------------------------------------------------------

  serialize :action_array, Array

  validates :action_type,     presence: true, inclusion: {in: 0..TYPES.size}
  validates :action_array,    presence: true
  validates :action_text,     presence: true, length: 2..2000, if: Proc.new{|a| [:popup, :highlight].include?(TYPES[a.action_type]) }


  # ---------------------------------------------------------------------------

  default_scope { where(active: true).order('sort_index ASC, id ASC') }


  # ---------------------------------------------------------------------------

  def name; TYPES[action_type]; end

  def to_api(*opts)
    opts = opts.extract_options!
    {id: id, action: name, timeout: action_timeout, array: action_array, text: action_text}
  end


private


end
