# frozen_string_literal: true

class User < ApplicationRecord
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  validates :name, presence: true
  validates :cpf, presence: true, uniqueness: true
  validates :email, presence: true, uniqueness: true
end
