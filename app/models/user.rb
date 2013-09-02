class User < ActiveRecord::Base
  has_secure_password

  attr_accessible :email, :password

  validates :password, length: { minimum: 6 }, if: :validate_password?
  validates :email, uniqueness: true, presence: true

  
  private 
  
    def validate_password?
      password.present?
    end

end
