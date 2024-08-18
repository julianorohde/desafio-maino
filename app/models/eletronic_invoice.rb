# frozen_string_literal: true

class EletronicInvoice < ApplicationRecord
  belongs_to :user

  validates :user, presence: true
end
