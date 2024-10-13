class CreatePaperStocks < ActiveRecord::Migration[7.0]
  def change
    create_table :paper_stocks do |t|
      t.references :user,      null: false, foreign_key: true
      t.string     :outline,   null: false
      t.string     :paper_url, null: false
      t.timestamps
    end
  end
end
