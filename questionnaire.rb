require "pstore"

STORE_NAME = "tendable.pstore"

QUESTIONS = {
  "q1" => "Can you code in Ruby?",
  "q2" => "Can you code in JavaScript?",
  "q3" => "Can you code in Swift?",
  "q4" => "Can you code in Java?",
  "q5" => "Can you code in C#?"
}.freeze

def do_prompt(store)
  yes_count = 0

  QUESTIONS.each do |question_key, question_text|
    answer = prompt_question(question_text)
    record_response(question_key, answer, store)
    yes_count += 1 if answer.start_with?('y')
  end

  current_run_rating, average_rating = calculate_ratings(yes_count, store)

  puts "Your rating for this run: #{current_run_rating}%"
  puts "Average rating over all runs: #{average_rating}%"
end

def do_report(store)
  if store.transaction { store[:total_runs].nil? || store[:total_runs].zero? }
    puts "No survey data available."
    return
  end

  store.transaction(true) do
    average_rating = calculate_average_rating(store[:total_yes_answers], store[:total_runs], QUESTIONS.size)
    puts "Total Runs: #{store[:total_runs]}"
    puts "Average rating over all runs: #{average_rating}%"
  end
end

private

def prompt_question(question)
  print "#{question} (Yes/No): "
  gets.chomp.downcase
end

def record_response(question_key, answer, store)
  store.transaction do
    store[question_key] ||= []
    store[question_key] << (answer.start_with?('y') ? 'Yes' : 'No')
  end
end

def calculate_ratings(yes_count, store)
  store.transaction do
    store[:total_runs] ||= 0
    store[:total_yes_answers] ||= 0
    store[:total_runs] += 1
    store[:total_yes_answers] += yes_count
    current_run_rating = calculate_run_rating(yes_count, QUESTIONS.size)
    average_rating = calculate_average_rating(store[:total_yes_answers], store[:total_runs], QUESTIONS.size)
    [current_run_rating, average_rating]
  end
end

def calculate_run_rating(yes_count, total_questions)
  (100.0 * yes_count / total_questions).round(2)
end

def calculate_average_rating(total_yes_answers, total_runs, total_questions)
  (100.0 * total_yes_answers / (total_runs * total_questions)).round(2)
end


store = PStore.new(STORE_NAME)
do_prompt(store)
do_report(store)
