# frozen_string_literal: true

# headless policy for bulk mails: authorize :bulk, :create?
class BulkPolicy < ApplicationPolicy
  allow :index?, :show?, to: %i[bulk bulk_notify]
  allow :create?, :send_mails?, to: :bulk
end
