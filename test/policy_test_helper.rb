# Helper for the policy tests in test/policies.
#
# Policy tests do not need a database: users are unsaved User objects with
# stubbed roles and access level, records are model classes or simple stubs and
# scopes are resolved against a FakeRelation. That's why this helper doesn't load
# rails/test_help (which checks the test schema and loads fixtures).
#
# The tests describe the behaviour of the main area policies as documented in
# docs/permissions.md. Run them with `bin/rails test test/policies`.
ENV["RAILS_ENV"] ||= "test"
require_relative "../config/environment"
require "active_support/testing/autorun"
require "active_support/test_case"

class PolicyTestCase < ActiveSupport::TestCase
  # Every test checks all personas: the ones listed as allowed must be permitted,
  # all others must be denied.
  PERSONAS = {
    admin:         { roles: %i[admin] },
    national:      { roles: %i[national] },
    accounting:    { roles: %i[accounting] },
    distinction:   { roles: %i[distinction] },
    festival:      { roles: %i[festival] },
    magazine:      { roles: %i[magazine] },
    bulk:          { roles: %i[bulk] },
    bulk_notify:   { roles: %i[bulk_notify] },
    public_data:   { roles: %i[public_data] },
    regional_role: { roles: %i[regional] },                   # legacy role, no restricting entity
    regional:      { entity_class: "RegionalOrganization" },  # regional access level
    member:        { entity_class: "Orchestra" },             # member access level (/mgl only)
    plain:         {}                                         # signed in, no roles
  }.freeze

  ALL = PERSONAS.keys.freeze
  NOBODY = [].freeze
  ADMIN = %i[admin].freeze
  NATIONAL = %i[admin national].freeze
  ACCOUNTING = %i[admin accounting].freeze

  # Stand-in for an ActiveRecord relation; returns which query a scope used.
  class FakeRelation
    def all = :all
    def none = :none
    def for_user(_user) = :for_user
  end

  def user_for(persona)
    config = PERSONAS.fetch(persona)
    roles = config.fetch(:roles, [])
    entity_class = config[:entity_class]

    User.allocate.tap do |user|
      user.define_singleton_method(:has_role?) { |role| roles.include?(role.to_sym) }
      user.define_singleton_method(:entity_class) { entity_class }
      user.define_singleton_method(:inspect) { "#<User #{persona}>" }
    end
  end

  # assert_permissions MemberDataPolicy, Member, :show?, NATIONAL + %i[regional]
  def assert_permissions(policy_class, record, actions, allowed)
    Array(actions).each do |action|
      PERSONAS.each_key do |persona|
        result = policy_class.new(user_for(persona), record).public_send(action)
        expected = allowed.include?(persona)
        assert_equal expected, result ? true : false,
                     "#{policy_class}##{action} should be #{expected ? 'allowed' : 'denied'} for #{persona}"
      end
    end
  end

  # assert_scope OrchestraPolicy, for_user: NATIONAL, none: ALL - NATIONAL
  def assert_scope(policy_class, expectations)
    covered = expectations.values.flatten
    assert_equal PERSONAS.keys.sort, covered.sort, "#{policy_class}::Scope: every persona must be listed exactly once"

    expectations.each do |expected, personas|
      personas.each do |persona|
        actual = policy_class::Scope.new(user_for(persona), FakeRelation.new).resolve
        assert_equal expected, actual, "#{policy_class}::Scope for #{persona}"
      end
    end
  end

  # standard CRUD actions incl. the new?/edit? aliases
  def assert_crud(policy_class, record, index:, show:, create:, update:, destroy:)
    assert_permissions policy_class, record, :index?, index
    assert_permissions policy_class, record, :show?, show
    assert_permissions policy_class, record, %i[create? new?], create
    assert_permissions policy_class, record, %i[update? edit?], update
    assert_permissions policy_class, record, :destroy?, destroy
  end
end
