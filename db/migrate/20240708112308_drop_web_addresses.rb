class DropWebAddresses < ActiveRecord::Migration[7.1]
  def change
    drop_table :web_addresses do |t|
      t.string :original_url
      t.string :short_url
      t.string :title
      t.timestamps null: false
    end
  end
end
