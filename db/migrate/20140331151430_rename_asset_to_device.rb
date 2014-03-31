class RenameAssetToDevice < ActiveRecord::Migration
  def change
    rename_table :assets, :devices
    PaperTrail::Version.all.each { |version| version.update!(item_type: "Device") }
  end
end
