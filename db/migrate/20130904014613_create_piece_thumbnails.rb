class CreatePieceThumbnails < ActiveRecord::Migration
  def change
    create_table :piece_thumbnails do |t|
      t.integer     :piece_id
      t.string      :piece_type
      t.string      :image_file_name
      t.integer     :image_file_size
      t.datetime    :image_updated_at
      t.boolean     :active,          :default => true
      t.timestamps
    end
  end
end
