# app/models/label.rb
class Label < ApplicationRecord
  belongs_to :user
  has_many :task_labels
  has_many :tasks, through: :task_labels, source: :task

  validates :name, presence: true
end