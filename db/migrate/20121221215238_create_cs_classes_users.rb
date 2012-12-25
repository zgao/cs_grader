class CreateCsClassesUsers < ActiveRecord::Migration
  def up
    create_table :cs_classes_users do |t|
      t.integer :cs_class_id
      t.integer :user_id
    end
  end

  def down
    drop_table :cs_classes_users
  end
end
