class AddAttachmentInputToTestCases < ActiveRecord::Migration
  def self.up
    change_table :test_cases do |t|
      t.has_attached_file :input
    end
  end

  def self.down
    drop_attached_file :test_cases, :input
  end
end
