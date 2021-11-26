# frozen_string_literal: true

class User < ApplicationRecord
  has_many :comments, dependent: :destroy
  has_many :articles, dependent: :destroy
  validates :first_name, presence: true
  validates :last_name, presence: true
  validates :gender, presence: true
  validates :address, presence: true
  validates :phone, presence: true
end
