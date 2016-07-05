require 'set'

class User < ActiveRecord::Base
  rolify

  include Authority::UserAbilities

  before_create :generate_api_token

  has_many :concerts

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
  #attr_accessible :username, :email, :password, :password_confirmation, :remember_me, :name, :role, :entity_class, :entity_id, :authentication_token

  # Virtual attribute for authenticating by either username or email
  # This is in addition to a real persisted field like 'username'
  attr_accessor :login
  #attr_accessible :login

  def self.find_first_by_auth_conditions(warden_conditions)
    conditions = warden_conditions.dup
    if login = conditions.delete(:login)
      where(conditions).where(["lower(username) = :value OR lower(email) = :value", { :value => login.downcase }]).first
    else
      where(conditions).first
    end
  end

  def self.for_admin_notify
    User.with_any_role(:admin, :accounting)
  end

  def first_role
    if (roles.empty?)
		  return 'personal'
    else
		  return roles[0]
	  end
  end

  def address?
	  return has_role? :address
  end

  def admin?
	  return has_role? :admin
  end

  def is_admin?
    return has_role? :admin
  end

  def bulk_permission?
	  return (has_role? :admin or has_role? :bulk)
  end

  def national_permission? 
    admin? or national?
  end

  def can_create_members?
    return ( has_role? :national or has_role? :admin)
  end

  def reference_data_permission?
    return national_permission?
  end

  def festival_permission?
    return national_permission?
  end

  def magazine_permission?
    return national_permission?
  end

  def accounting_permission?
    return (has_role? :accounting or has_role? :admin)
  end

  def accounting?
	  return has_role? :accounting
  end

  def gema?
 	  return has_role? :gema
  end

  def national?
	  return has_role? :national
  end

  def honor?
	  return has_role? :distinction
  end

  def is_restricted_role?
	  return has_role? :restricted
  end

  def is_member?
	  return has_role? :member
  end

  def self.gen_api_token
    begin
      token = SecureRandom.hex
    end while User.exists?(authentication_token: token)

    return token
  end

  def restricting_entity
    if has_role? :member 
        member = PersonMember.with_role(:member, self).first
      if member.nil? then
        member = Orchestra.with_role(:member,self).first
      end 
    end
  end

  def to_s
    if username.nil? then
      email
    else
      username
    end
  end

  private 
  def generate_api_token
    begin
      self.authentication_token = SecureRandom.hex
    end while self.class.exists?(authentication_token: self.authentication_token)
  end


end
