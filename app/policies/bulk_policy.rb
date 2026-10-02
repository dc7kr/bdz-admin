# frozen_string_literal: true

class BulkPolicy < ApplicationPolicy
  attr_reader :user, :record

  def initialize(user, record)
    @user = user
    @record = record
  end

  def index?
    permitted?(:bulk, :bulk_notify)
  end

  def show?
    permitted?(:bulk, :bulk_notify) 
  end

  def create?
    permitted?(:bulk)
  end

  def send_mails?
    permitted?(:bulk)
  end

end
