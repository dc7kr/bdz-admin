class User < ApplicationRecord
  rolify

  include Authority::UserAbilities

  before_create :generate_api_token

  has_many :concerts

  # Include default devise modules. Others available are:
  # :token_authenticatable, :encryptable, :confirmable, :lockable, :timeoutable and :omniauthable
  # FUTURE: async mailers !
  # devise :database_authenticatable, :async, :recoverable, :rememberable, :trackable, :validatable, :authentication_keys => [:login]
  devise :database_authenticatable, :recoverable, :rememberable, :trackable, :validatable,
         authentication_keys: [ :login ]

  validates :username,
            uniqueness: {
              case_sensitive: false
            }

  # Setup accessible (or protected) attributes for your model
  # attr_accessible :username, :email, :password, :password_confirmation, :remember_me, :name, :role, :entity_class, :entity_id, :authentication_token

  # Virtual attribute for authenticating by either username or email
  # This is in addition to a real persisted field like 'username'
  attr_accessor :login

  # attr_accessible :login

  def self.find_first_by_auth_conditions(warden_conditions)
    conditions = warden_conditions.dup
    if (login = conditions.delete(:login))
      where(conditions).where([ "lower(username) = :value OR lower(email) = :value", { value: login.downcase } ]).first
    else
      where(conditions).first
    end
  end

  def self.for_admin_notify
    User.with_any_role(:admin, :accounting)
  end

  def self.for_developer_notify
    retval = []
    retval << User.find(1)
  end

  def first_role
    return "personal" if roles.empty?

    roles[0]
  end

  def address?
    has_role? :address
  end

  def admin?
    has_role? :admin
  end

  def is_admin?
    has_role? :admin
  end

  def tools_permission?
    (has_role? :admin or has_role? :accounting)
  end

  def bulk_permission?
    (has_role? :admin or has_role? :bulk)
  end

  def national_permission?
    admin? or national?
  end

  def can_create_members?
    (has_role? :national or has_role? :admin)
  end

  def reference_data_permission?
    national_permission?
  end

  def festival_permission?
    national_permission?
  end

  def magazine_permission?
    national_permission?
  end

  def accounting_permission?
    (has_role? :accounting or has_role? :admin)
  end

  def accounting?
    has_role? :accounting
  end

  def gema?
    has_role? :gema
  end

  def national?
    has_role? :national
  end

  def honor?
    has_role? :distinction
  end

  def is_restricted_role?
    has_role? :restricted
  end

  def is_member?
    has_role? :member
  end

  def self.gen_api_token
    loop do
      token = SecureRandom.hex
      break unless User.exists?(authentication_token: token)
    end

    token
  end

  def restricting_entity
    return unless has_role? :member

    member = PersonMember.with_role(:member, self).first
    return unless member.nil?

    Orchestra.with_role(:member, self).first
  end

  def to_s
    if username.nil?
      email
    else
      username
    end
  end

  private

  def generate_api_token
    loop do
      self.authentication_token = SecureRandom.hex
      break unless self.class.exists?(authentication_token: authentication_token)
    end
  end
end
