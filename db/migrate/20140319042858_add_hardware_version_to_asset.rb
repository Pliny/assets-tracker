class AddHardwareVersionToAsset < ActiveRecord::Migration
  def change
    add_column :assets, :hardware_version_id, :integer
  end
end
