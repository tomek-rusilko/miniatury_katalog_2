# == Schema Information
#
# Table name: users
#
#  id         :integer         not null, primary key
#  name       :string(255)
#  email      :string(255)
#  created_at :datetime        not null
#  updated_at :datetime        not null
#

class User < ActiveRecord::Base
  attr_accessible :name, :email, :password, :password_confirmation
  has_secure_password

  validates :name, 	presence: 	true, 
  					length:   	{ within: 3..50}
  
  regex = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
  
  validates :email, presence: 	true,
                    format: 	{ with: regex },
                    uniqueness: { case_sensitive: false }

  validates :password, length: { minimum: 6 }

end
