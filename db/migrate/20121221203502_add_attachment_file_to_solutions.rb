class AddAttachmentFileToSolutions < ActiveRecord::Migration
  def self.up
    change_table :solutions do |t|
      t.has_attached_file :file
    end
  end

  def self.down
    drop_attached_file :solutions, :file
  end
end
