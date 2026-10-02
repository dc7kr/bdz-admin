# Named permissions used by the policies, see docs/permissions.md.
#
#   permitted?(:national, :distinction)  # true if the user has any of them
#
# Role based permissions always include admins. The access level permissions
# (:regional, :member) and :signed_in don't.
module Permissions
  ROLES = %i[admin national accounting distinction festival bulk bulk_notify public_data].freeze

  # legacy role, only still used by UserPolicy and MagazineSamplingPolicy
  LEGACY_ROLES = { regional_role: :regional }.freeze

  ACCESS_LEVELS = { regional: :regional_level?, member: :member_level? }.freeze

  def permitted?(*names)
    names.any? { |name| permission?(name) }
  end

  # used by views, e.g. policy(FestivalApplication).accounting_permission?
  def national_permission?
    permitted?(:national)
  end

  def accounting_permission?
    permitted?(:accounting)
  end

  private

  def permission?(name)
    if ROLES.include?(name)
      user.has_role?(:admin) || user.has_role?(name)
    elsif LEGACY_ROLES.key?(name)
      user.has_role?(:admin) || user.has_role?(LEGACY_ROLES[name])
    elsif ACCESS_LEVELS.key?(name)
      user.public_send(ACCESS_LEVELS[name])
    elsif name == :signed_in
      user.present?
    else
      raise ArgumentError, "unknown permission: #{name.inspect}"
    end
  end
end
