class AddDraftAndUrlAtToRallies < ActiveRecord::Migration[7.0]
  def change
    add_column :rallies, :draft, :boolean, null: false, default: true
    add_column :rallies, :url,   :string,  null: false
  end
end
