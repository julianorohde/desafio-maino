# frozen_string_literal: true

require 'rails_helper'

RSpec.describe User, type: :model do
  describe '#valid?' do
    it { should validate_presence_of(:name) }
    it { should validate_presence_of(:cpf) }
    it { should validate_presence_of(:email) }

    it 'does not allow duplicate CPF values' do
      user = create(:user)
      duplicate_user = build(:user, cpf: user.cpf)

      expect(duplicate_user).not_to be_valid
      expect(duplicate_user.errors[:cpf]).to include('has already been taken')
    end

    it 'does not allow duplicate email addresses' do
      user = create(:user)
      duplicate_user = build(:user, email: user.email)

      expect(duplicate_user).not_to be_valid
      expect(duplicate_user.errors[:email]).to include('has already been taken')
    end
  end

  describe '#devise authentication' do
    it { should have_db_column(:encrypted_password) }
    it { should have_db_column(:reset_password_token) }
    it { should have_db_column(:remember_created_at) }

    it { should_not allow_value(nil).for(:email) }
    it { should allow_value(Faker::Internet.email).for(:email) }
  end
end
