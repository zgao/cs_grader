require 'benchmark'

class GradingJob < Struct.new(:solution)
  @run_as = false #true for sandbox mode
  @run_as_user = 'caged_animal'
  @run_as_pass = 'letmeout'

  def perform
    @test_cases_passed = 0
    @file_path = solution.file.path
    @file_dir = @file_path.split('/')[0...-1].join('/')
    puts "file dir detected: #{@file_dir}"
    @file_name = @file_path.split('/').last
    puts "file name: #{@file_name}"
    extension = @file_path.split('.').last
    solution.comments = ""
    solution.problem.test_cases.each do |test_case|
      puts "testing #{test_case.id}"
      @test_case = test_case
      @input_path = test_case.input.path
      puts "input: #{@input_path}"
      @output_path = test_case.output.path
      puts "output: #{@output_path}"
      case extension
      when 'cpp', 'c'
        evaluate_cpp
      when 'jar'
        evaluate_java
      when 'py'
        evaluate_python
      end
    end
    solution.test_cases_passed = @test_cases_passed
    solution.tested = true
    solution.validated = (solution.problem.test_cases.count == @test_cases_passed)
    solution.update_maximums
    solution.save!
    #update status
  end

  def run_as(str)
    system (@run_as ? "echo #{@run_as_pass} | sudo -S -u #{@run_as_user} " : "") + str
  end

  def evaluate_cpp
    begin
      Dir.chdir @file_dir
      puts "Working directory: #{@file_dir}"
      puts "In working directory. Compiling..."
      run_as "g++ #{@file_name} -o #{solution.id}.out"
      system @run_as_pass if @run_as
      puts "Compiled."
      system "cp #{@input_path} #{@file_dir}/input.in"
      puts "Copied file."
      times = Benchmark.measure { run_as "timeout #{solution.problem_time_limit} ./#{solution.id}.out" }
      system "cp #{@output_path} #{@file_dir}/compare.out"
      correct = FileUtils.compare_file("output.out", 'compare.out') ? 1 : 0
      if correct == 1
        puts "passed #{@test_case.id}, used #{times.real}s"
        solution.comments += "passed #{@test_case.id}, used #{times.real}s\n"
      else
        puts "failed #{@test_case.id}, used #{times.real}s"
        solution.comments += "failed #{@test_case.id}, used #{times.real}s\n"
      end
      @test_cases_passed += correct
    rescue StandardError
      puts "failed #{@test_case.id}, serious problem"
      solution.comments += "failed #{@test_case.id}, serious problem\n"
    end
  end

  def evaluate_java
    begin
      Dir.chdir @file_dir
      puts "In working directory: #{@file_dir}"
      system "cp #{@input_path} #{@file_dir}/input.in"
      puts "Copied file."
      times = Benchmark.measure { run_as "timeout #{solution.problem_time_limit} java Main" }
      system "cp #{@output_path} #{@file_dir}/compare.out"
      correct = FileUtils.compare_file("output.out", 'compare.out') ? 1 : 0
      if correct == 1
        puts "passed #{@test_case.id}, used #{times.real}s"
        solution.comments += "passed #{@test_case.id}, used #{times.real}s\n"
      else
        puts "failed #{@test_case.id}, used #{times.real}s"
        solution.comments += "failed #{@test_case.id}, used #{times.real}s\n"
      end
      @test_cases_passed += correct
    rescue StandardError
      puts "failed #{@test_case.id}, serious problem"
      solution.comments += "failed #{@test_case.id}, serious problem\n"
    end
  end

  def evaluate_python

  end
end
