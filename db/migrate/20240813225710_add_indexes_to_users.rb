# frozen_string_literal: true

class AddIndexesToUsers < ActiveRecord::Migration[7.1]
  disable_ddl_transaction!

  def change
    add_index :users, :email, unique: true, algorithm: :concurrently
    add_index :users, :cpf, unique: true, algorithm: :concurrently
    add_index :users, :reset_password_token, unique: true, algorithm: :concurrently
  end
end
