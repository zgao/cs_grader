class CreateSolutions < ActiveRecord::Migration
  def change
    create_table :solutions do |t|
      t.references :user
      t.references :problem
      t.boolean :validated
      t.integer :test_cases_passed

      t.timestamps
    end
    add_index :solutions, :user_id
    add_index :solutions, :problem_id
  end
end
