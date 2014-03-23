class AddMetadataToVersions < ActiveRecord::Migration
  def change
    add_column :versions, :metadata, :string
  end
end
