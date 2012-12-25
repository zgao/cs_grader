class CreateSolutionStates < ActiveRecord::Migration
  def change
    create_table :solution_states do |t|
      t.references :user
      t.references :problem
      t.references :solution
      t.integer :test_cases_passed
      t.integer :test_cases_total
      t.string :comments

      t.timestamps
    end
    add_index :solution_states, :user_id
    add_index :solution_states, :problem_id
    add_index :solution_states, :solution_id
  end
end
