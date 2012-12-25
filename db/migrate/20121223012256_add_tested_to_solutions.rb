class AddTestedToSolutions < ActiveRecord::Migration
  def change
    add_column :solutions, :tested, :boolean
  end
end
