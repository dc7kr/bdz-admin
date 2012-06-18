require 'set'

class User < ActiveRecord::Base

  # Include default devise modules. Others available are:
  # :token_authenticatable, :encryptable, :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable
 

  # Setup accessible (or protected) attributes for your model
  attr_accessible :email, :password, :password_confirmation, :remember_me

  ROLES = %w[admin gs]

  def first_role
    if (roles.empty?)
		return 'personal'
    else
		return roles[0]
	end
  end
  def roles
	if ( self.role == nil ) 
		[]
	else
		self.role.split(' ')
	end
  end 
  def address?
	return roles.include?('address')
  end
  def admin?
	return roles.include?('admin')
  end
  def national?
	return roles.include?('national')
  end

  def honor?
	return roles.include?('honor')
  end
end
