class CreateSections < ActiveRecord::Migration

  def change
    create_table :sections do |t|
      t.integer     :exhibition_id
      t.string      :slug
      t.string      :title
      t.string      :subtitle
      t.string      :excerpt
      t.text        :description
      t.integer     :sort_index,            default: 9999
      t.boolean     :active,                default: true
      t.timestamps
    end

    add_index :sections, [:exhibition_id]
    add_index :sections, [:slug], unique: true
  end

end
