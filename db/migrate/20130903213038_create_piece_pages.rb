class CreatePiecePages < ActiveRecord::Migration
  def change
    create_table :piece_pages do |t|
      t.string        :slug
      t.text          :url
      t.string        :cache_page_file_name
      t.integer       :cache_page_file_size
      t.string        :cache_page_content_type
      t.string        :cache_page_updated_at
      t.date          :timeline_date
      t.integer       :timeline_year
      t.string        :title
      t.string        :excerpt
      t.text          :description
      t.string        :author
      t.string        :organization
      t.string        :focus_position
      t.string        :focus_keywords
      t.boolean       :option_glass,              :default => false
      t.boolean       :option_clickable,          :default => true
      t.boolean       :active,                    :default => true
      t.timestamps
    end

    add_index :piece_pages, [:slug], :unique => true
  end
end
