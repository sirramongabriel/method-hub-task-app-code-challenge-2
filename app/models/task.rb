class Task < ApplicationRecord
  validates :title, :description, :date_due, :priority_level, presence: true
  validates :progress, numericality: { greater_than_or_equal_to: 0, less_than_or_equal_to: 100 }

  belongs_to :user, optional: true
end
