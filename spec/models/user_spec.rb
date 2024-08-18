# frozen_string_literal: true

require 'rails_helper'

RSpec.describe User, type: :model do
  let!(:user) { create(:user) }

  describe '#validations' do
    it { should validate_presence_of(:name) }
    it { should validate_presence_of(:cpf) }
    it { should validate_presence_of(:email) }

    it 'does not allow duplicate CPF values' do
      duplicate_user = build(:user, cpf: user.cpf)

      expect(duplicate_user).not_to be_valid
      expect(duplicate_user.errors[:cpf]).to include('já está em uso')
    end

    it 'does not allow duplicate email addresses' do
      duplicate_user = build(:user, email: user.email)

      expect(duplicate_user).not_to be_valid
      expect(duplicate_user.errors[:email]).to include('já está em uso')
    end
  end

  describe '#associations' do
    it { should have_many(:eletronic_invoices) }
  end

  describe '#columns' do
    it { should have_db_column(:encrypted_password) }
    it { should have_db_column(:reset_password_token) }
    it { should have_db_column(:remember_created_at) }

    it { should_not allow_value(nil).for(:email) }
    it { should allow_value(Faker::Internet.email).for(:email) }
  end
end
