# frozen_string_literal: true

class Article < ApplicationRecord
  belongs_to :user, dependent: :destroy
  has_many :comments, dependent: :destroy
end
