# frozen_string_literal: true

class CreateEletronicInvoices < ActiveRecord::Migration[7.1]
  def up
    create_table :eletronic_invoices do |t|
      t.references :user, null: false
      t.string :serie
      t.string :n_nf
      t.timestamp :dh_emi
      t.string :emit
      t.string :dest

      t.timestamps
    end
  end

  def down
    drop_table :eletronic_invoices
  end
end
