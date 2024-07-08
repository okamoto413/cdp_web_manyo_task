# app/models/label.rb
class Label < ApplicationRecord
  belongs_to :user
  has_many :task_labels
  has_many :tasks, through: :task_labels, source: :task

belongs_to:owner,
          class_name: 'User',
          foreign_key: 'user_id'

  validates :name, presence: true
end
