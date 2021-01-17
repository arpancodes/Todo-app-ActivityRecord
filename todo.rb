require "active_record"

class Todo < ActiveRecord::Base
  def due_today?
    due_date == Date.today
  end

  def overdue?
    due_date < Date.today
  end

  def due_later?
    due_date > Date.today
  end

  def self.overdue_todos
    all.filter { |todo| todo.overdue? }.map { |todo| todo.to_displayable_string }.join("\n")
  end

  def self.due_today_todos
    all.filter { |todo| todo.due_today? }.map { |todo| todo.to_displayable_string }.join("\n")
  end

  def self.due_later_todos
    all.filter { |todo| todo.due_later? }.map { |todo| todo.to_displayable_string }.join("\n")
  end

  def to_displayable_string
    display_status = completed ? "[X]" : "[ ]"
    display_date = due_today? ? nil : due_date
    "#{id}. #{display_status} #{todo_text} #{display_date}"
  end

  def self.to_displayable_list
    all.map { |todo| todo.to_displayable_string }
  end

  def self.show_list
    puts "My Todo-list\n\n"

    puts "Overdue\n"
    puts overdue_todos
    puts "\n\n"

    puts "Due Today\n"
    puts due_today_todos
    puts "\n\n"

    puts "Due Later\n"
    puts due_later_todos
    puts "\n\n"
  end

  def self.add_task(task)
    create!(todo_text: task[:todo_text], due_date: Date.today + task[:due_in_days], completed: false)
  end

  def self.mark_as_complete!(todo_id)
    todo = find(todo_id)
    todo.completed = true
    todo.save
    todo
  end
end
