class CreateExhibitionUsers < ActiveRecord::Migration

  def change
    create_table :exhibition_users do |t|
      t.integer       :exhibition_id
      t.integer       :user_id
      t.integer      :permission_level,    default: 0
      t.timestamps
    end
  end

end
