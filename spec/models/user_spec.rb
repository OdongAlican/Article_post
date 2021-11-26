# frozen_string_literal: true

require 'rails_helper'

RSpec.describe User, type: :model do
  it { should validate_presence_of(:first_name) }
  it { should validate_presence_of(:last_name) }
  it { should validate_presence_of(:gender) }
  it { should validate_presence_of(:address) }
  it { should validate_presence_of(:phone) }
end
