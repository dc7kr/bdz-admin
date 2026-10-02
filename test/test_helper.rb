ENV['RAILS_ENV'] ||= 'test'
require_relative '../config/environment'
require 'rails/test_help'

module ActiveSupport
  class TestCase
    # Run tests in parallel with specified workers
    parallelize(workers: :number_of_processors)

    # Setup all fixtures in test/fixtures/*.yml for all tests in alphabetical order.
    fixtures :all

    # Add more helper methods to be used by all tests here...

    # a signed up user with the given roles, optionally restricted to an entity
    def create_user(*roles, restricting_entity: nil)
      name = "user#{SecureRandom.hex(4)}"
      user = User.create!(username: name, email: "#{name}@example.com", password: "secret-password",
                          restricting_entity: restricting_entity)
      roles.each { |role| user.add_role(role) }
      user
    end

    def create_regional_organization(number)
      RegionalOrganization.create!(nummer: number, name: "Landesverband #{number}")
    end

    # columns that are NOT NULL in the test database, which is built from the migrations
    def member_attributes(mglnr, regional_organization)
      { mglnr: mglnr, eintritt: Date.new(2020, 1, 1), regional_organization: regional_organization, za: "R",
        subtype: "", anrede: "Herr", vorname: "Max", name: "Muster #{mglnr}",
        strasse: "Hauptstr. 1", plz: "12345", ort: "Musterstadt" }
    end
  end
end

module ActionDispatch
  class IntegrationTest
    include Devise::Test::IntegrationHelpers
  end
end
