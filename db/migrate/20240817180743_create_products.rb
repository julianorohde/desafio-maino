# frozen_string_literal: true

class CreateProducts < ActiveRecord::Migration[7.1]
  def up
    create_table :products do |t|
      t.references :eletronic_invoice, null: false
      t.string :x_prod
      t.string :ncm
      t.string :cfop
      t.string :u_com
      t.decimal :q_com
      t.decimal :v_un_com
      t.decimal :v_icms
      t.decimal :v_ipi
      t.decimal :v_pis
      t.decimal :v_cofins
      t.decimal :v_total

      t.timestamps
    end
  end

  def down
    drop_table :products
  end
end
