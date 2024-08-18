# frozen_string_literal: true

FactoryBot.define do
  factory :product do
    association :eletronic_invoice

    x_prod { Faker::Commerce.product_name }
    ncm { Faker::Number.number(digits: 8) }
    cfop { Faker::Number.number(digits: 4) }
    u_com { Faker::Commerce.material }
    q_com { Faker::Number.decimal(l_digits: 2) }
    v_un_com { Faker::Number.decimal(l_digits: 2) }
    v_icms { Faker::Number.decimal(l_digits: 2) }
    v_ipi { Faker::Number.decimal(l_digits: 2) }
    v_pis { Faker::Number.decimal(l_digits: 2) }
    v_cofins { Faker::Number.decimal(l_digits: 2) }
  end
end
