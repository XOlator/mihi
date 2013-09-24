class CreatePiecePageEvents < ActiveRecord::Migration

  def change
    create_table :piece_page_events do |t|
      t.integer     :piece_page_id
      t.integer     :action_type,           default: 0
      t.integer     :action_timeout,        default: 0
      t.string      :action_array
      t.text        :action_text
      t.integer     :sort_index,            default: 9999
      t.boolean     :active,                default: true
      t.timestamps
    end

    add_index :piece_page_events, [:piece_page_id]
  end

end
