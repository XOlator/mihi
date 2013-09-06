class CreatePieceTexts < ActiveRecord::Migration
  def change
    create_table :piece_texts do |t|
      t.string        :slug
      t.string        :title
      t.text          :content
      t.integer       :position
      t.string        :theme
      t.boolean       :active,        default: true
      t.timestamps
    end

    add_index :piece_texts, [:slug], unique: true
  end
end
