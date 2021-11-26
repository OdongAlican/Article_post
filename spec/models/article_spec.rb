# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Article, type: :model do
  it { should belong_to(:user) }
  it { should have_many(:comments) }
  it { should validate_presence_of(:title) }
  it { should validate_presence_of(:content) }
end
