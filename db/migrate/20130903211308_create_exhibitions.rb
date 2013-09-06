class CreateExhibitions < ActiveRecord::Migration

  def change
    create_table :exhibitions do |t|
      t.string        :slug
      t.string        :title
      t.string        :subtitle
      t.string        :excerpt
      t.text          :description
      t.string        :theme
      t.datetime      :publish_at
      t.datetime      :unpublish_at
      t.boolean       :option_glass,              :default => false
      t.boolean       :option_playable,           :default => true
      t.boolean       :option_wifi_restricted,    :default => false
      t.boolean       :active,                    :default => true
      t.timestamps
    end

    add_index :exhibitions, [:slug], :unique => true
  end

end
