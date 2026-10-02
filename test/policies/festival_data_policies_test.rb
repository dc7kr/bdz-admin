require "policy_test_helper"

# Festival data policies, see docs/permissions.md#festival-data
class FestivalDataPoliciesTest < PolicyTestCase
  NATIONAL_FESTIVAL = (NATIONAL + %i[festival]).freeze

  test "festival data defaults" do
    [ FestivalDataPolicy, FestivalMealPolicy, EventCardPolicy ].each do |policy_class|
      assert_crud policy_class, :festival_data,
                  index: NOBODY, show: NATIONAL_FESTIVAL,
                  create: NATIONAL, update: NATIONAL, destroy: NOBODY
      assert_scope policy_class, all: NATIONAL, none: ALL - NATIONAL
    end
  end

  test "festival applications" do
    assert_crud FestivalApplicationPolicy, FestivalApplication,
                index: NOBODY, show: NATIONAL_FESTIVAL,
                create: NATIONAL, update: NATIONAL, destroy: NATIONAL
    assert_permissions FestivalApplicationPolicy, FestivalApplication,
                       %i[fee_invoice_preview? fee_invoice? ticket_invoice_preview? gen_ticket_invoice? ticket_invoice?
                          no_tickets? no_meals? finalize? storno? gen_participant_sheet? participant_overview?],
                       NATIONAL
    assert_permissions FestivalApplicationPolicy, FestivalApplication, %i[stage_plans? datasheets?], NATIONAL_FESTIVAL
    assert_scope FestivalApplicationPolicy, all: NATIONAL_FESTIVAL, none: ALL - NATIONAL_FESTIVAL
  end

  test "festival concerts" do
    assert_crud FestivalConcertPolicy, FestivalConcert,
                index: NOBODY, show: NATIONAL_FESTIVAL,
                create: NATIONAL, update: NATIONAL, destroy: NATIONAL
    assert_permissions FestivalConcertPolicy, FestivalConcert, %i[programme? details?], NATIONAL_FESTIVAL
    assert_scope FestivalConcertPolicy, all: NATIONAL_FESTIVAL, none: ALL - NATIONAL_FESTIVAL
  end

  test "festival exhibitors" do
    assert_crud FestivalExhibitorPolicy, FestivalExhibitor,
                index: NOBODY, show: NATIONAL_FESTIVAL,
                create: NATIONAL, update: NATIONAL, destroy: NOBODY
    assert_permissions FestivalExhibitorPolicy, FestivalExhibitor, %i[invoice_preview? gen_invoice? storno?], NATIONAL
    assert_scope FestivalExhibitorPolicy, all: NATIONAL_FESTIVAL, none: ALL - NATIONAL_FESTIVAL
  end

  test "festival pieces" do
    assert_crud FestivalPiecePolicy, FestivalPiece,
                index: NOBODY, show: NATIONAL_FESTIVAL,
                create: NATIONAL, update: NATIONAL, destroy: NATIONAL
    assert_scope FestivalPiecePolicy, all: NATIONAL_FESTIVAL, none: ALL - NATIONAL_FESTIVAL
  end

  test "event cards" do
    assert_permissions EventCardPolicy, EventCard, %i[invoice_preview? storno? pickup? overview?], NATIONAL
  end

  test "event meals" do
    assert_crud EventMealPolicy, EventMeal,
                index: NOBODY, show: NATIONAL_FESTIVAL,
                create: NATIONAL, update: NATIONAL, destroy: NOBODY
    assert_permissions EventMealPolicy, EventMeal, :arrival_overview?, NATIONAL_FESTIVAL
    assert_scope EventMealPolicy, all: NATIONAL_FESTIVAL, none: ALL - NATIONAL_FESTIVAL
  end

  test "festival mails use the bulk policy" do
    assert_permissions FestivalMailPolicy, :festival_mail, %i[index? show?], %i[admin bulk bulk_notify]
    assert_permissions FestivalMailPolicy, :festival_mail, %i[create? new? send_mails?], %i[admin bulk]
  end
end
