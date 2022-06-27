class User < ApplicationRecord
  validates :name, presence: true, length: { minimum: 2 }
  validates :email, presence: true, uniqueness: true, format: { with: URI::MailTo::EMAIL_REGEXP }
  validates :phone, presence: true, format: { with: /\A(01)[0-46-9]-*[0-9]{7,8}\z/ }
  validates :password, presence: true, length: { minimum: 5 }

  has_secure_password
end
