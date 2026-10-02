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
    assert_not permitted(:admin, :member)
    assert permitted(:regional, :regional)
    assert permitted(:member, :member)
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
