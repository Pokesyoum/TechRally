class CreateUserMissions < ActiveRecord::Migration[7.0]
  def change
    create_table :user_missions do |t|
      t.references :user,      null: false
      t.references :mission,   null: false
      t.boolean    :completed, default: false
      t.timestamps
    end
  end
end
