class AddArchiveOrgUrlToPiecePages < ActiveRecord::Migration

  def change
    add_column :piece_pages, :wayback_url, :string, after: :url
    add_column :piece_pages, :wayback_date, :datetime, after: :wayback_url
  end

end
