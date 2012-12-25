class CreateRequests < ActiveRecord::Migration
  def change
    create_table :requests do |t|
      t.references :user
      t.references :cs_class

      t.timestamps
    end
    add_index :requests, :user_id
    add_index :requests, :cs_class_id
  end
end
