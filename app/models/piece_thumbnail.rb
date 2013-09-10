class PieceThumbnail < ActiveRecord::Base

  include Activatable


  # ---------------------------------------------------------------------------

  has_attached_file :image, 
    # S3 HERE
    styles: {thumbnail: ""},
    convert_options: {thumbnail: "-gravity north -thumbnail 300x300^ -extent 300x300"}


  # ---------------------------------------------------------------------------

  belongs_to :piece, polymorphic: true


  # ---------------------------------------------------------------------------

  default_scope { where(active: true) }


  # ---------------------------------------------------------------------------


private


end
