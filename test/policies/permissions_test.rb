require "policy_test_helper"

class PermissionsTest < PolicyTestCase
  def permitted(persona, *names)
    ApplicationPolicy.new(user_for(persona), :record).permitted?(*names)
  end

  test "role permissions include admins" do
    Permissions::ROLES.each do |role|
      assert permitted(:admin, role), "admin should have #{role}"
    end
    assert permitted(:admin, :regional_role)
  end

  test "access level permissions do not include admins" do
    assert_not permitted(:admin, :regional)
    assert permitted(:regional, :regional)
  end

  test "member area access is not a main area permission" do
    assert_raises(ArgumentError) { permitted(:admin, :member) }
  end

  test "access levels of users" do
    assert_equal :admin, user_for(:admin).access_level
    assert_equal :regional, user_for(:regional).access_level

    # accounts restricted to an orchestra / person member by an earlier version
    %w[Orchestra PersonMember].each do |entity_class|
      user = User.allocate
      user.define_singleton_method(:entity_class) { entity_class }

      assert_equal :none, user.access_level
      assert_not user.admin_level?
      assert_not user.regional_level?
    end
  end

  test "any of several permissions" do
    assert permitted(:distinction, :national, :distinction)
    assert_not permitted(:festival, :national, :distinction)
  end

  test "signed in" do
    assert permitted(:plain, :signed_in)
  end

  test "unknown permission" do
    assert_raises(ArgumentError) { permitted(:admin, :superuser) }
  end

  test "scopes have the same permissions" do
    scope = ApplicationPolicy::Scope.new(user_for(:national), FakeRelation.new)
    assert scope.permitted?(:national)
    assert_not scope.permitted?(:accounting)
  end

  test "allow defines actions and subclasses may redefine them" do
    base = Class.new(ApplicationPolicy) { allow :show?, :custom?, to: %i[national festival] }
    sub = Class.new(base) { allow :custom?, to: [] }

    assert_permissions base, :record, %i[show? custom?], NATIONAL + %i[festival]
    assert_permissions sub, :record, :show?, NATIONAL + %i[festival]
    assert_permissions sub, :record, :custom?, NOBODY
  end
end
