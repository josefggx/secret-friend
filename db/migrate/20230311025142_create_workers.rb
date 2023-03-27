class CreateWorkers < ActiveRecord::Migration[7.0]
  def change
    create_table :workers do |t|
      t.string :name
      t.string :year_in_work, default: DateTime.current.year
      t.references :location, index: true, foreign_key: {to_table: :locations}

      t.timestamps
    end
  end
end
