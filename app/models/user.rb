require 'set'

class User < ActiveRecord::Base

  # Include default devise modules. Others available are:
  # :token_authenticatable, :encryptable, :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable, :authentication_keys => [:login]
 

  # Setup accessible (or protected) attributes for your model
  attr_accessible :username, :email, :password, :password_confirmation, :remember_me, :name

  # Virtual attribute for authenticating by either username or email
  # This is in addition to a real persisted field like 'username'
  attr_accessor :login
  attr_accessible :login

  ROLES = %w[admin gs]

  def self.find_first_by_auth_conditions(warden_conditions)
    conditions = warden_conditions.dup
    if login = conditions.delete(:login)
      where(conditions).where(["lower(username) = :value OR lower(email) = :value", { :value => login.downcase }]).first
    else
      where(conditions).first
    end
  end

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
  def is_member?
	return roles.include?('member')
  end
end
