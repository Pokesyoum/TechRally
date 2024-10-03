class CreateRallies < ActiveRecord::Migration[7.0]
  def change
    create_table :rallies do |t|
      t.references :user,       null: false, foreign_key: true
      t.string     :title,      null: false
      t.text       :abstract,   null: false
      t.text       :background
      t.text       :idea
      t.text       :method
      t.text       :result
      t.text       :discussion
      t.text       :conclusion, null: false
      t.text       :opinion,    null: false
      t.timestamps
    end
  end
end
