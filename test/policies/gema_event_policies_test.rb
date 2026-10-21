require "policy_test_helper"
require "minitest/mock"

class GemaEventPoliciesTest < PolicyTestCase
  REGION_ORCHESTRA_IDS = [ 7, 8 ].freeze

  # stands in for Orchestra.for_user(user) of a regional user
  class FakeOrchestras
    def pluck(_column) = REGION_ORCHESTRA_IDS
    def exists?(id:) = REGION_ORCHESTRA_IDS.include?(id)
  end

  # GemaEvent criteria; returns which query a scope used
  class FakeCriteria < FakeRelation
    attr_reader :condition

    def where(condition)
      @condition = condition
      self
    end
  end

  def event(orchestra_id) = Struct.new(:orchestra_id).new(orchestra_id)

  def with_region(&block) = Orchestra.stub(:for_user, FakeOrchestras.new, &block)

  test "main area: national users have full access, regional users read" do
    with_region do
      assert_crud GemaEventPolicy, GemaEvent,
                  index: NATIONAL + %i[regional], show: NATIONAL + %i[regional],
                  create: NATIONAL, update: NATIONAL, destroy: NATIONAL
    end
  end

  test "main area: regional users only read events of orchestras in their region" do
    with_region do
      assert_permissions GemaEventPolicy, event(7), :show?, NATIONAL + %i[regional]
      assert_permissions GemaEventPolicy, event(99), :show?, NATIONAL
      assert_permissions GemaEventPolicy, event(nil), :show?, NATIONAL
      assert_permissions GemaEventPolicy, event(7), %i[update? destroy?], NATIONAL
    end
  end

  test "main area scope" do
    with_region do
      assert_equal :all, GemaEventPolicy::Scope.new(user_for(:national), FakeCriteria.new).resolve

      criteria = GemaEventPolicy::Scope.new(user_for(:regional), FakeCriteria.new).resolve
      assert_equal({ :orchestra_id.in => REGION_ORCHESTRA_IDS }, criteria.condition)

      (ALL - NATIONAL - %i[regional]).each do |persona|
        assert_equal :none, GemaEventPolicy::Scope.new(user_for(persona), FakeCriteria.new).resolve, persona
      end
    end
  end

  # the member area policies get a Mgl::MemberContext, not a User
  def member_context(entity)
    Mgl::MemberContext.new(user: nil, entity: entity, impersonating: false)
  end

  test "member area: orchestra members read the events of their orchestra" do
    orchestra = Orchestra.allocate
    orchestra.define_singleton_method(:id) { 7 }
    context = member_context(orchestra)

    assert Mgl::GemaEventPolicy.new(context, GemaEvent).index?
    assert Mgl::GemaEventPolicy.new(context, event(7)).show?
    assert_not Mgl::GemaEventPolicy.new(context, event(8)).show?
    assert_not Mgl::GemaEventPolicy.new(context, event(7)).update?
    assert_not Mgl::GemaEventPolicy.new(context, event(7)).destroy?

    criteria = Mgl::GemaEventPolicy::Scope.new(context, FakeCriteria.new).resolve
    assert_equal({ orchestra_id: 7 }, criteria.condition)
  end

  test "member area: without an entity there is no access" do
    context = member_context(nil)

    assert_not Mgl::GemaEventPolicy.new(context, GemaEvent).index?
    assert_not Mgl::GemaEventPolicy.new(context, event(7)).show?
    assert_equal :none, Mgl::GemaEventPolicy::Scope.new(context, FakeCriteria.new).resolve
  end
end
