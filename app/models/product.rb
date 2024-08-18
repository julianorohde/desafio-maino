# frozen_string_literal: true

class Product < ApplicationRecord
  belongs_to :eletronic_invoice, required: true

  before_save :calculate_total

  private

  def calculate_total
    self.v_total = (q_com * v_un_com) + v_icms + v_ipi + v_pis + v_cofins
  end
end
