class CreateUsers < ActiveRecord::Migration
  def change
    create_table :users do |t|
      t.string :remember_token
      t.string :google_id
      t.string :google_token
      t.string :first_name
      t.string :last_name
      t.string :email
      t.string :google_hd
      t.string :google_image_url

      t.timestamps
    end
  end
end
