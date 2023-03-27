class CreateCouples < ActiveRecord::Migration[7.0]
  def change
    create_table :couples do |t|
      t.references :first_worker, null: false, foreign_key: { to_table: :workers }
      t.references :second_worker, null: false, foreign_key: { to_table: :workers }
      t.references :game, null: false, foreign_key: true

      t.timestamps
    end

    add_index :couples, %i[first_worker_id second_worker_id game_id],
              unique: true, name: 'index_couples_on_workers_and_game'
  end
end
