# frozen_string_literal: true

class ApplicationPolicy
  include Permissions

  attr_reader :user, :record

  def initialize(user, record)
    @user = user
    @record = record
  end

  # Defines actions that are allowed for any of the given permissions:
  #
  #   allow :index?, :show?, to: %i[national regional]
  #   allow :destroy?, to: []    # nobody
  #
  # Subclasses inherit the actions and may redefine them with allow or def.
  def self.allow(*actions, to:)
    names = Array(to).freeze
    actions.each do |action|
      define_method(action) { permitted?(*names) }
    end
  end

  def index?
    false
  end

  def show?
    false
  end

  def create?
    false
  end

  def new?
    create?
  end

  def update?
    false
  end

  def edit?
    update?
  end

  def destroy?
    false
  end

  class Scope
    include Permissions

    def initialize(user, scope)
      @user = user
      @scope = scope
    end

    def resolve
      raise NoMethodError, "You must define #resolve in #{self.class}"
    end

    # all records for users with any of the permissions, none for everybody else
    def all_if_permitted(*names)
      permitted?(*names) ? scope.all : scope.none
    end

    private

    attr_reader :user, :scope
  end
end
