# frozen_string_literal: true

class EletronicInvoice < ApplicationRecord
  belongs_to :user
  has_many :products

  validates :user, presence: true
end
