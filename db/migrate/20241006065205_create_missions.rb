class CreateMissions < ActiveRecord::Migration[7.0]
  def change
    create_table :missions do |t|
      t.string :description, null: false
      t.timestamps
    end
  end
end
