require "test_helper"

class FestivalApplicationMailerTest < ActionMailer::TestCase
  setup do
    @application = FestivalApplication.create!(conductor: "Erika Dirigentin", num_players: 12, orch_name: "Testorchester",
                                               token: SecureRandom.uuid)
    @application.create_contact_person!(first_name: "Max", last_name: "Muster", email: "max@example.com", phone: "0123")
  end

  test "confirm_create" do
    mail = FestivalApplicationMailer.confirm_create(@application.token)
    assert_equal [ "max@example.com" ], mail.to
    assert_not_empty mail.subject
    assert_not_empty mail.body.encoded
  end

  test "confirm_update" do
    mail = FestivalApplicationMailer.confirm_update(@application.token)
    assert_equal [ "max@example.com" ], mail.to
    assert_not_empty mail.body.encoded
  end
end
