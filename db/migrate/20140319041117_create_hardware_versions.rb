class CreateHardwareVersions < ActiveRecord::Migration
  def change
    create_table :hardware_versions do |t|
      t.string :name
      t.text :description
      t.string :project

      t.timestamps
    end
  end
end
