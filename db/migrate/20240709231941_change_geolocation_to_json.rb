class ChangeGeolocationToJson < ActiveRecord::Migration[7.1]
  def up
    # SQL to updates previous non-JSON data.
    execute <<-SQL
      UPDATE visits
      SET geolocation = '{}'  -- Default value
      WHERE geolocation IS NULL OR geolocation = '' OR geolocation !~ '^[{[]';
    SQL

    # SQL to Alter the column type
    execute <<-SQL
      ALTER TABLE visits
      ALTER COLUMN geolocation TYPE json USING geolocation::json;
    SQL
  end

  def down
    # Revert the column type back to string
    change_column :visits, :geolocation, :string
  end
end
