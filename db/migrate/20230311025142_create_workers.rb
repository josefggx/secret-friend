class CreateWorkers < ActiveRecord::Migration[7.0]
  def change
    create_table :workers do |t|
      t.string :name, null: false
      t.string :year_in_work, default: DateTime.current.year, null: false
      t.references :location, index: true, foreign_key: { to_table: :locations }, null: false

      t.timestamps
    end
  end
end
