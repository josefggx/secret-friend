class AddLocationToWorkers < ActiveRecord::Migration[7.0]
  def change
    add_reference :workers, :location, null: false, foreign_key: true
  end
end
