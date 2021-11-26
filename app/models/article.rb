# frozen_string_literal: true

class Article < ApplicationRecord
  belongs_to :user, dependent: :destroy
  has_many :comments, dependent: :destroy
  validates :title, presence: true
  validates :content, presence: true
end
