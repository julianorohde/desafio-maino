# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Product, type: :model do
  describe '#associations' do
    it { should belong_to(:eletronic_invoice).required(true) }
  end

  describe '#callbacks' do
    let(:user) { create(:user) }
    let(:eletronic_invoice) { create(:eletronic_invoice, user:) }
    let(:product) { build(:product, eletronic_invoice:) }

    it 'calculates the total before saving' do
      product.save

      expect(product.v_total).to eq((product.q_com * product.v_un_com) + product.v_icms + product.v_ipi + product.v_pis + product.v_cofins)
    end
  end
end
