# frozen_string_literal: true

class AdminPolicy < ApplicationPolicy
  attr_reader :user, :record

  def initialize(user, record)
    @user = user
    @record = record
  end

  def index?
    permitted?(:admin)
  end

  def show?
    permitted?(:admin)
  end

end
