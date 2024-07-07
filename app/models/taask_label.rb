# app/models/task_label.rb
class TaskLabel < ApplicationRecord
    belongs_to :task
    belongs_to :label
end    