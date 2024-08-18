# frozen_string_literal: true

require 'rails_helper'

RSpec.describe EletronicInvoice, type: :model do
  describe '#valid?' do
    it { should validate_presence_of(:user) }
  end

  describe '#associations' do
    it { should belong_to(:user) }
    it { should have_many(:products) }
  end
end
