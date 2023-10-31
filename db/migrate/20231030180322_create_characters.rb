class CreateCharacters < ActiveRecord::Migration[7.1]
  def change
    create_table :characters do |t|
      t.string :name
      t.string :status
      t.string :species
      t.string :character_type
      t.string :gender
      t.string :origin
      t.string :location
      t.string :image
      t.text :episode
      t.string :url
      t.datetime :created

      t.timestamps
    end
  end
end
