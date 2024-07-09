class CreateVisits < ActiveRecord::Migration[7.1]
  def change
    create_table :visits do |t|
      t.references :link, null: false, foreign_key: true
      t.string :geolocation
      t.datetime :timestamp

      t.timestamps
    end
  end
end
