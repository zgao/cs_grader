class HomeController < ApplicationController
  def index
    "
    if user_signed_in?
      if current_user.admin?
        @problems = Problem.all
      else
        @problems = current_user.cs_classes.collect {|x| x.problems}.flatten
        @best_solutions = Hash[*@problems.collect do |x|
          all_solutions = x.solutions.
            where(:user_id => current_user.id).
            where('created_at <= ?', x.due_date).order('test_cases_passed desc')
          if all_solutions.nil?
            [x.id, nil]
          else
            [x.id, all_solutions.first]
          end
        end.flatten]
        @best_all_time = Hash[*@problems.collect do |x|
          all_solutions = x.solutions.
            where(:user_id => current_user.id).order('test_cases_passed desc')
          if all_solutions.nil?
            [x.id, nil]
          else
            [x.id, all_solutions.first]
          end
        end.flatten]
      end
    end"

    if user_signed_in?
      if current_user.admin?
        @cs_classes = CsClass.all
        @problems = {}
        @cs_classes.each do |cs_class|
          @problems[cs_class] = {}
          cs_class.visible_problems(current_user).each do |problem|
            @problems[cs_class][problem] = {}
            @problems[cs_class][problem][:name] = problem.name
            @problems[cs_class][problem][:due_date] = problem.due_date.to_date.to_s
            @problems[cs_class][problem][:number_solutions] = problem.solutions.count
            @problems[cs_class][problem][:number_correct_solutions] = problem.solutions.where(validated: true).count
            @problems[cs_class][problem][:average_test_cases] =
              Float(problem.solutions.collect {|x| x.test_cases_passed}.inject(:+)) / problem.solutions.count
            @problems[cs_class][problem][:success_rate] =
              100 * Float(@problems[cs_class][problem][:number_correct_solutions]) / @problems[cs_class][problem][:number_solutions]
          end
        end
      else
        @cs_classes = current_user.cs_classes
        @problems = {}
        @cs_classes.each do |cs_class|
          @problems[cs_class] = {}
          cs_class.visible_problems(current_user).each do |problem|
            @problems[cs_class][problem] = {}
            @problems[cs_class][problem][:name] = problem.name
            @problems[cs_class][problem][:due_date] = problem.due_date.to_date.to_s
            @problems[cs_class][problem][:attempts] = problem.solutions.where(user_id: current_user.id).count
            solution_state = SolutionState.where(problem_id: problem.id, user_id: current_user.id)
            if solution_state.count >= 1
              solution_state = solution_state.first
              @problems[cs_class][problem][:solution_exists] = true
              @problems[cs_class][problem][:best_try] = solution_state.test_cases_ratio
              @problems[cs_class][problem][:best_solution] = solution_state.solution
            else
              @problems[cs_class][problem][:solution_exists] = false
              @problems[cs_class][problem][:best_try] = "None"
              @problems[cs_class][problem][:best_solution] = nil
            end
          end
        end
      end
    end
    render "index"
  end
end
