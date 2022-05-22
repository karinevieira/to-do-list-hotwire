# frozen_string_literal: true

class Task < ApplicationRecord
  validates :name, presence: true

  belongs_to :user

  scope :ordered, -> { order(id: :desc) }
  scope :search, ->(name) { where("LOWER(name) LIKE ?", "%#{name.downcase}%") if name.present? }
end
