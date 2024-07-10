class AddOriginalUrlIconToLink < ActiveRecord::Migration[7.1]
  def change
    add_column :links, :icon_url, :string
  end
end
