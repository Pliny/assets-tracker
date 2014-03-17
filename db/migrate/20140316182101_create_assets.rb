class CreateAssets < ActiveRecord::Migration
  def change
    create_table :assets do |t|
      t.string  :serial_no
      t.integer :user_id
      t.string  :mac_address
      t.text    :notes
      t.boolean :in_house
      t.string  :ipv4_address

      t.timestamps
    end
  end
end
