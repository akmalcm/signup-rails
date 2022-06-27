class CreateUsers < ActiveRecord::Migration[5.1]
  def change
    create_table :users do |t|
      t.string :name, null: false
      t.string :email, null: false, unique: true
      t.string :phone, null: false, unique: true
      t.string :role, null: false, default: 'standard'
      t.string :password_digest, null: false
      t.timestamps
    end
  end
end
