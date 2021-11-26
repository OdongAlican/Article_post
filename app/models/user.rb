# frozen_string_literal: true

class User < ApplicationRecord
  has_many :comments, dependent: :destroy
  has_many :articles, dependent: :destroy
end
