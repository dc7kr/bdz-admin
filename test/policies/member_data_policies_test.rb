require "policy_test_helper"

# Member data policies, see docs/permissions.md#member-data
class MemberDataPoliciesTest < PolicyTestCase
  NATIONAL_REGIONAL = (NATIONAL + %i[regional]).freeze
  NATIONAL_DISTINCTION = (NATIONAL + %i[distinction]).freeze

  # policies that use the MemberDataPolicy defaults
  DEFAULT_POLICIES = {
    MemberPolicy => Member,
    OrchestraContactPolicy => OrchestraContact,
    RegionalOrganizationPolicy => RegionalOrganization,
    StatePolicy => State,
    TariffPolicy => Tariff,
    AdvertiserPolicy => Advertiser,
    MagazineIssuePolicy => MagazineIssue,
    ContactEventPolicy => ContactEvent,
    ContactPersonPolicy => ContactPerson,
    MemberEventPolicy => MemberEvent,
    ReportSheetPolicy => ReportSheet,
    ReportSheetInputPolicy => ReportSheetInput
  }.freeze

  DEFAULT_POLICIES.each do |policy_class, model|
    test "#{policy_class} uses the member data defaults" do
      assert_crud policy_class, model,
                  index: NATIONAL, show: NATIONAL_REGIONAL,
                  create: NATIONAL, update: NATIONAL, destroy: NATIONAL
    end
  end

  test "member data default scope" do
    [ MemberDataPolicy, MemberPolicy, StatePolicy, ReportSheetPolicy, ContactEventPolicy ].each do |policy_class|
      assert_scope policy_class, all: NATIONAL, nil => ALL - NATIONAL
    end
  end

  test "contact person scope includes festival" do
    allowed = NATIONAL + %i[festival]
    assert_scope ContactPersonPolicy, all: allowed, nil => ALL - allowed
  end

  test "orchestras" do
    assert_crud OrchestraPolicy, Orchestra,
                index: NATIONAL, show: NATIONAL_REGIONAL + %i[distinction],
                create: NATIONAL, update: NATIONAL, destroy: NATIONAL
    assert_permissions OrchestraPolicy, Orchestra, :invoice_preview?, ACCOUNTING
    assert_scope OrchestraPolicy,
                 for_user: NATIONAL_REGIONAL + %i[distinction],
                 none: ALL - NATIONAL_REGIONAL - %i[distinction]
  end

  test "person members" do
    assert_crud PersonMemberPolicy, PersonMember,
                index: NOBODY, show: NATIONAL_REGIONAL,
                create: NATIONAL, update: NATIONAL, destroy: NOBODY
    assert_permissions PersonMemberPolicy, PersonMember, :invoice_preview?, ACCOUNTING
    assert_scope PersonMemberPolicy, for_user: NATIONAL_REGIONAL, none: ALL - NATIONAL_REGIONAL
  end

  test "orchestra members" do
    assert_crud OrchestraMemberPolicy, OrchestraMember,
                index: NATIONAL_DISTINCTION, show: NATIONAL_REGIONAL + %i[distinction],
                create: NATIONAL, update: NATIONAL, destroy: NATIONAL
    assert_permissions OrchestraMemberPolicy, OrchestraMember, :exchange?, NATIONAL
    assert_scope OrchestraMemberPolicy, all: NATIONAL_DISTINCTION, nil => ALL - NATIONAL_DISTINCTION
  end

  test "distinctions" do
    unbooked = Struct.new(:member_account_booking).new(nil)
    booked = Struct.new(:member_account_booking).new(:booking)

    assert_permissions DistinctionPolicy, Distinction, :index?, NATIONAL
    assert_permissions DistinctionPolicy, Distinction, %i[show? create? new?], NATIONAL_DISTINCTION
    assert_permissions DistinctionPolicy, Distinction, %i[invoice_preview? gen_invoice?], ACCOUNTING + %i[distinction]
    assert_permissions DistinctionPolicy, unbooked, %i[update? edit? destroy?], NATIONAL_DISTINCTION
    assert_permissions DistinctionPolicy, booked, %i[update? edit? destroy?], ADMIN
    assert_scope DistinctionPolicy, all: NATIONAL_DISTINCTION, nil => ALL - NATIONAL_DISTINCTION
  end

  test "honor members" do
    assert_crud HonorMemberPolicy, HonorMember,
                index: NATIONAL, show: NATIONAL_REGIONAL + %i[distinction],
                create: NATIONAL_DISTINCTION, update: NATIONAL_DISTINCTION, destroy: NATIONAL
    assert_scope HonorMemberPolicy, all: NATIONAL_DISTINCTION, nil => ALL - NATIONAL_DISTINCTION
  end

  test "member events" do
    assert_permissions MemberEventPolicy, MemberEvent, :download?, NATIONAL
  end

  test "report sheets" do
    assert_permissions ReportSheetPolicy, ReportSheet, :invoice_preview?, NATIONAL + %i[accounting]
    assert_permissions ReportSheetPolicy, ReportSheet, :update_invoice?, ACCOUNTING
    assert_permissions ReportSheetPolicy, ReportSheet, :copy_from_last_year?, NATIONAL
    assert_permissions ReportSheetInputPolicy, ReportSheetInput, :metadata?, NATIONAL
  end

  test "downloads" do
    assert_permissions DownloadPolicy, :download, :index?, NATIONAL
    assert_permissions DownloadPolicy, :download,
                       %i[combined_letters_pdf? combined_sepa_pdf? combined_invoice_pdf? combined_sepa?], ACCOUNTING
  end

  test "regional organization reports" do
    assert_crud Report::RegionalOrganizationPolicy, RegionalOrganization,
                index: NATIONAL, show: NATIONAL_REGIONAL,
                create: NATIONAL, update: NATIONAL, destroy: NATIONAL
    assert_permissions Report::RegionalOrganizationPolicy, RegionalOrganization,
                       %i[members? orchestras? person_members?], NATIONAL
  end

  test "member account bookings" do
    manual = Struct.new(:booking_mode).new("M")
    automatic = Struct.new(:booking_mode).new("A")

    assert_permissions MemberAccountBookingPolicy, MemberAccountBooking, :index?, NOBODY
    assert_permissions MemberAccountBookingPolicy, MemberAccountBooking, :show?, NATIONAL
    assert_permissions MemberAccountBookingPolicy, MemberAccountBooking, %i[create? new?], ACCOUNTING
    assert_permissions MemberAccountBookingPolicy, manual, %i[update? edit?], ACCOUNTING
    assert_permissions MemberAccountBookingPolicy, automatic, %i[update? edit?], ADMIN
    assert_permissions MemberAccountBookingPolicy, MemberAccountBooking, :destroy?, ADMIN
    assert_permissions MemberAccountBookingPolicy, MemberAccountBooking, %i[invoice_preview? invoice_sepa?], ACCOUNTING
    assert_permissions MemberAccountBookingPolicy, MemberAccountBooking, :download?, NATIONAL_DISTINCTION
    assert_scope MemberAccountBookingPolicy, all: NATIONAL_DISTINCTION, nil => ALL - NATIONAL_DISTINCTION
  end
end
