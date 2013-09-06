class CreateExhibitionPieces < ActiveRecord::Migration
  def change
    create_table :exhibition_pieces do |t|
      t.integer     :exhibition_id
      t.string      :piece_type
      t.integer     :piece_id
      t.integer     :sort_index,                default: 9999
      t.integer     :section_id
      t.integer     :section_sort_index,        default: 9999
      t.boolean     :active,                    default: true
      t.timestamps
    end

    add_index :exhibition_pieces, [:slug, :piece_type, :piece_id], unique: true
  end
end
