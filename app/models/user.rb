require 'set'

class User < ActiveRecord::Base
  rolify

  before_create :generate_api_token

  # Include default devise modules. Others available are:
  # :token_authenticatable, :encryptable, :confirmable, :lockable, :timeoutable and :omniauthable
  # FUTURE: async mailers !
  #devise :database_authenticatable, :async, :recoverable, :rememberable, :trackable, :validatable, :authentication_keys => [:login]
  devise :database_authenticatable, :recoverable, :rememberable, :trackable, :validatable, :authentication_keys => [:login]

  
  validates :username,
  :uniqueness => {
    :case_sensitive => false
  }

 

  # Setup accessible (or protected) attributes for your model
  attr_accessible :username, :email, :password, :password_confirmation, :remember_me, :name, :role, :entity_class, :entity_id, :authentication_token

  # Virtual attribute for authenticating by either username or email
  # This is in addition to a real persisted field like 'username'
  attr_accessor :login
  attr_accessible :login

  ROLES = %w[admin gs distinction ]

  def self.find_first_by_auth_conditions(warden_conditions)
    conditions = warden_conditions.dup
    if login = conditions.delete(:login)
      where(conditions).where(["lower(username) = :value OR lower(email) = :value", { :value => login.downcase }]).first
    else
      where(conditions).first
    end
  end

  def self.for_admin_notify
    where("role like ? or role like ?", "%accounting%", "%admin%")
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

  def reference_data_permission?
    return (admin? or national?)
  end

  def festival_permission?
    return (admin? or national?)
  end

  def magazine_permission?
    return (admin? or national?)
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

  def is_restricted_role?
	  return roles.include?('restricted')
  end

  def is_member?
	  return roles.include?('member')
  end

  def self.gen_api_token
    begin
      token = SecureRandom.hex
    end while User.exists?(authentication_token: token)

    return token
  end

  def restricting_entity
    if entity_class.nil? then
      return nil
    end

    entityClass = Object.const_get(entity_class) 

    restricting_entity = entityClass.find(entity_id)
    Rails.logger.info("Entity Class for User: "+entityClass.to_s+" Object: "+restricting_entity.to_s)

    return restricting_entity
  end

  private 
  def generate_api_token
    begin
      self.authentication_token = SecureRandom.hex
    end while self.class.exists?(authentication_token: self.authentication_token)
  end
end
