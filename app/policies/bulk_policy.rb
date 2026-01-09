# frozen_string_literal: true

class BulkPolicy < ApplicationPolicy
  attr_reader :user, :record

  def initialize(user, record)
    @user = user
    @record = record
  end

  def index?
    user.has_role? :bulk or user.has_role? :bulk_notify or user.has_role? :admin
  end

  def show?
    user.has_role? :bulk or user.has_role? :bulk_notify or user.has_role? :admin 
  end

  def create?
    user.has_role? :bulk  or user.has_role? :admin
  end

  def send_mails?
    user.has_role? :bulk  or user.has_role? :admin
  end

end
