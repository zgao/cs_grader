class CreateCsClasses < ActiveRecord::Migration
  def change
    create_table :cs_classes do |t|
      t.string :name
      t.string :description

      t.timestamps
    end
  end
end
