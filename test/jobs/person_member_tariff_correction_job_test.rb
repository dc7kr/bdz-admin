require "test_helper"

class PersonMemberTariffCorrectionJobTest < ActiveJob::TestCase
  IBAN = "DE89370400440532013000".freeze
  BIC = "COBADEFFXXX".freeze

  setup do
    @region = create_regional_organization(95)
    @regular = Tariff.create!(tariff_type: 20, description: "Einzelmitglied", amount: 46, tag: "em")
    @youngster = Tariff.create!(tariff_type: 25, description: "Youngster", amount: 24, tag: "em_youngster")
    @digital = Tariff.create!(tariff_type: 21, description: "Digital", amount: 36, tag: "em_digital")
    @foreign = Tariff.create!(tariff_type: 23, description: "Ausland", amount: 50, tag: "em_foreign")
    @honorary = Tariff.create!(tariff_type: 29, description: "Ehrenmitglied", amount: 0)
    @seq = 95_000
  end

  test "youngster turning 28 with email and direct debit becomes digital" do
    pm = person_member(@youngster, born: 1999)
    PersonMemberTariffCorrectionJob.perform_now(2027)
    assert_equal @digital, pm.reload.tariff
  end

  test "youngster turning 28 without email becomes regular" do
    pm = person_member(@youngster, born: 1999, email: nil)
    PersonMemberTariffCorrectionJob.perform_now(2027)
    assert_equal @regular, pm.reload.tariff
  end

  test "youngster turning 28 without direct debit becomes regular" do
    pm = person_member(@youngster, born: 1999, debit: false)
    PersonMemberTariffCorrectionJob.perform_now(2027)
    assert_equal @regular, pm.reload.tariff
  end

  test "youngster stays youngster until the year they turn 28" do
    pm = person_member(@youngster, born: 1999)
    PersonMemberTariffCorrectionJob.perform_now(2026)
    assert_equal @youngster, pm.reload.tariff
  end

  test "youngster without birthday is not touched" do
    pm = person_member(@youngster, born: nil)
    PersonMemberTariffCorrectionJob.perform_now(2027)
    assert_equal @youngster, pm.reload.tariff
  end

  test "members outside germany get the international tariff" do
    [ @regular, @youngster, @digital ].each do |tariff|
      pm = person_member(tariff, born: 2005, country: "CH")
      PersonMemberTariffCorrectionJob.perform_now(2027)
      assert_equal @foreign, pm.reload.tariff, "from #{tariff.tag}"
    end
  end

  test "country code is matched case insensitively" do
    pm = person_member(@regular, country: "de")
    PersonMemberTariffCorrectionJob.perform_now(2027)
    assert_equal @regular, pm.reload.tariff
  end

  test "digital members without email or direct debit are reset to regular" do
    no_mail = person_member(@digital, email: nil)
    no_debit = person_member(@digital, debit: false)
    ok = person_member(@digital)
    PersonMemberTariffCorrectionJob.perform_now(2027)
    assert_equal @regular, no_mail.reload.tariff
    assert_equal @regular, no_debit.reload.tariff
    assert_equal @digital, ok.reload.tariff
  end

  test "regular german members and german members on the international tariff are left alone" do
    regular = person_member(@regular)
    foreign = person_member(@foreign)
    PersonMemberTariffCorrectionJob.perform_now(2027)
    assert_equal @regular, regular.reload.tariff
    assert_equal @foreign, foreign.reload.tariff
  end

  test "other tariffs are not touched even abroad" do
    pm = person_member(@honorary, country: "AT")
    PersonMemberTariffCorrectionJob.perform_now(2027)
    assert_equal @honorary, pm.reload.tariff
  end

  test "admins are notified about changes only" do
    admin = create_user(:admin)
    person_member(@regular)
    assert_no_difference -> { ActionMailer::Base.deliveries.size } do
      PersonMemberTariffCorrectionJob.perform_now(2027)
    end

    pm = person_member(@youngster, born: 1999)
    assert_difference -> { ActionMailer::Base.deliveries.size }, 1 do
      PersonMemberTariffCorrectionJob.perform_now(2027)
    end
    mail = ActionMailer::Base.deliveries.last
    assert_equal [ admin.email ], mail.to
    assert_includes mail.body.to_s, pm.member.mglnr.to_s
  end

  private

  def person_member(tariff, born: 1990, email: "mail@example.com", debit: true, country: "DE")
    @seq += 1
    attrs = member_attributes(@seq.to_s, @region).merge(email: email, country_code: country)
    attrs.merge!(za: "L", iban: IBAN, bic: BIC) if debit
    PersonMember.create!(tariff: tariff, geburtstag: born && Date.new(born, 9, 9), member_attributes: attrs)
  end
end
