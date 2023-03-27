class CreateGames < ActiveRecord::Migration[7.0]
  def change
    create_table :games do |t|
      t.integer :year_game
      t.text :workers, array: true, default: []
      t.references :worker_without_play, foreign_key: { to_table: :workers }

      t.timestamps
    end
  end
end
