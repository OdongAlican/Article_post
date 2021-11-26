# frozen_string_literal: true

class Comment < ApplicationRecord
  belongs_to :user, dependent: :destroy
  belongs_to :article, dependent: :destroy
end
