class AddLockedFlagToExhibitions < ActiveRecord::Migration

  def change
    add_column :exhibitions, :locked, :boolean, default: false, after: :active
  end

end
