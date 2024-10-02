class CreateRallies < ActiveRecord::Migration[7.0]
  def change
    create_table :rallies do |t|

      t.timestamps
    end
  end
end
