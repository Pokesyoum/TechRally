class CreateLookForPapers < ActiveRecord::Migration[7.0]
  def change
    create_table :look_for_papers do |t|
      t.references :user,           null: false, foreign_key: true
      t.string     :look_for_paper, null: false
      t.string     :journal
      t.string     :search_word
      t.timestamps
    end
  end
end
