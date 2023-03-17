class CreateNotPlayingWorkers < ActiveRecord::Migration[7.0]
  def change
    create_table :not_playing_workers do |t|
      t.references :game, null: false, foreign_key: true
      t.references :worker, null: false, foreign_key: true

      t.timestamps
    end
  end
end
