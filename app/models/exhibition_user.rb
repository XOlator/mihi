class ExhibitionUser < ActiveRecord::Base

  include Activatable


  # ---------------------------------------------------------------------------

  PERMISSION_LEVELS = [:curator, :admin]


  # ---------------------------------------------------------------------------

  belongs_to :exhibition
  belongs_to :user


  # ---------------------------------------------------------------------------


private


end
