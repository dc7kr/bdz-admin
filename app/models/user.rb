class User < ApplicationRecord
  rolify

  before_create :generate_api_token
  before_create :generate_webauthn_id

  has_many :concerts
  has_many :passkeys, dependent: :destroy

  # Restricts the data a user may see (see #access_level):
  #   nil                   - no restriction, access is controlled by roles only
  #   RegionalOrganization  - members of that regional organization (main area)
  #   Orchestra             - only that orchestra (member area below /mgl)
  #   PersonMember          - only that person member (member area below /mgl)
  RESTRICTING_ENTITY_TYPES = %w[RegionalOrganization Orchestra PersonMember].freeze
  MEMBER_ENTITY_TYPES = %w[Orchestra PersonMember].freeze

  belongs_to :restricting_entity, polymorphic: true, optional: true,
                                  foreign_key: :entity_id, foreign_type: :entity_class

  validates :entity_class, inclusion: { in: RESTRICTING_ENTITY_TYPES }, allow_blank: true
  validates :restricting_entity, presence: true, if: -> { entity_class.present? }
  validate :restricting_mglnr_must_exist

  # required by devise-passkeys
  def self.passkeys_class
    Passkey
  end

  # required by devise-passkeys
  def self.find_for_passkey(passkey)
    find_by(id: passkey.user_id)
  end

  # Include default devise modules. Others available are:
  # :token_authenticatable, :encryptable, :confirmable, :lockable, :timeoutable and :omniauthable
  # FUTURE: async mailers !
  # devise :database_authenticatable, :async, :recoverable, :rememberable, :trackable, :validatable, :authentication_keys => [:login]
  devise :database_authenticatable, :registerable, :recoverable, :rememberable, :trackable, :validatable, :passkey_authenticatable,
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

  scope :for_admin_notify, -> { with_any_role(:admin, :accounting) }

  def self.find_first_by_auth_conditions(warden_conditions)
    conditions = warden_conditions.dup
    if (login = conditions.delete(:login))
      where(conditions).where([ "lower(username) = :value OR lower(email) = :value", { value: login.downcase } ]).first
    else
      where(conditions).first
    end
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

  def member_data_permission?
    national_permission? or regional_level? or has_role? :distinction
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
    national_permission? or has_role? :festival
  end

  def magazine_permission?
    national_permission? or has_role? :magazine
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

  # :admin, :regional or :member
  def access_level
    if entity_class.blank?
      :admin
    elsif entity_class == "RegionalOrganization"
      :regional
    else
      :member
    end
  end

  def admin_level?
    access_level == :admin
  end

  def regional_level?
    access_level == :regional
  end

  # orchestra and person member users only have access to the member area below /mgl
  def member_level?
    access_level == :member
  end

  # the Member record (mglnr, address, account) of the restricting entity
  def restricting_member
    restricting_entity&.member
  end

  # mglnr of the restricting entity, used to assign it in the user admin
  def restricting_mglnr
    return @restricting_mglnr if defined?(@restricting_mglnr)

    restricting_member&.mglnr
  end

  def restricting_mglnr=(value)
    @restricting_mglnr = value.to_s.strip.presence
    self.restricting_entity = @restricting_mglnr && Member.find_by(mglnr: @restricting_mglnr)&.member_entity
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

  def generate_webauthn_id
    self.webauthn_id ||= WebAuthn.generate_user_id
  end

  def restricting_mglnr_must_exist
    return if @restricting_mglnr.blank? || restricting_entity.present?

    errors.add(:restricting_mglnr, :invalid)
  end
end
