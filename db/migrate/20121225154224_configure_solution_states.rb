class ConfigureSolutionStates < ActiveRecord::Migration
  def up
    User.all.each do |user|
      user.cs_classes.collect {|csc| csc.problems}.flatten.each do |problem|
        solutions = Solution.where(user_id: user.id, problem_id: problem.id, tested: true)
        if solutions.count >= 1
          solution_state = problem.solution_states.new
          solution_state.user = user
          solutions.each do |solution|
            if solution.test_cases_passed > solution_state.test_cases_passed
              solution_state.test_cases_passed = solution.test_cases_passed
              solution_state.solution = solution
              solution_state.comments = solution.comments
            end
          end
          solution_state.save
        end
      end
    end
  end

  def down
    SolutionState.all.each {|x| x.destroy}
  end
end
