# frozen_string_literal: true

FactoryBot.define do
  factory :eletronic_invoice do
    association :user

    serie { Faker::Number.number(digits: 1) }
    n_nf { Faker::Number.number(digits: 6) }
    dh_emi { Faker::Time.between(from: 2.days.ago, to: Time.now) }
    emit { "#{Faker::Company.brazilian_company_number}#{Faker::Company.name}#{Faker::Address.full_address}#{Faker::PhoneNumber.cell_phone_in_e164}" }
    dest { "#{Faker::Company.brazilian_company_number}#{Faker::Company.name}#{Faker::Address.full_address}#{Faker::PhoneNumber.cell_phone_in_e164}" }
  end
end
