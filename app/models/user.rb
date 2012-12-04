require 'set'

class User < ActiveRecord::Base

  # Include default devise modules. Others available are:
  # :token_authenticatable, :encryptable, :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable, :token_authenticatable
 

  # Setup accessible (or protected) attributes for your model
  attr_accessible :email, :password, :password_confirmation, :remember_me,:name

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

  def has_role?(role)
	return roles.include?(role)
  end

  def admin?
	return roles.include?('admin')
  end

  def cron_permission?
	return (roles.include?('admin') or roles.include?('national'))
  end

  def accounting?
	return roles.include?('accounting')
  end

  def gema?
 	return roles.include?('gema')
  end

  def national?
	return roles.include?('national')
  end

  def honor?
	return roles.include?('distinction')
  end
end
