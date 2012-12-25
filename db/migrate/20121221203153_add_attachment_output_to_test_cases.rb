class AddAttachmentOutputToTestCases < ActiveRecord::Migration
  def self.up
    change_table :test_cases do |t|
      t.has_attached_file :output
    end
  end

  def self.down
    drop_attached_file :test_cases, :output
  end
end
