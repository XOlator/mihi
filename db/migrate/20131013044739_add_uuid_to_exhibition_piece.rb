class AddUuidToExhibitionPiece < ActiveRecord::Migration

  def up
    add_column :exhibition_pieces, :uuid, :string, after: :slug
    add_index :exhibition_pieces, [:uuid], unique: true

    ExhibitionPiece.find_each do |p|
      next unless p.uuid.blank?
      while true
        p.uuid = SecureRandom.hex(5)
        break unless ExhibitionPiece.where(uuid: p.uuid).count > 0
      end
      p.save
    end
  end

  def down
    remove_index :exhibition_pieces, [:uuid]
    remove_column :exhibition_pieces, :uuid
  end

end
