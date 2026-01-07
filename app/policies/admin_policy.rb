# frozen_string_literal: true

class AdminPolicy < ApplicationPolicy
  attr_reader :user, :record

  def initialize(user, record)
    @user = user
    @record = record
  end

  def index?
    user.has_role? :admin
  end

  def show?
    user.has_role? :admin
  end

end
