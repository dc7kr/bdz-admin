require "policy_test_helper"

# Magazine, public data, administration and tools, see docs/permissions.md
class OtherPoliciesTest < PolicyTestCase
  test "magazine contexts" do
    assert_crud MagazineContextPolicy, :magazine_context,
                index: NOBODY, show: NATIONAL, create: NATIONAL, update: NATIONAL, destroy: NOBODY
  end

  test "magazine samplings" do
    assert_crud MagazineSamplingPolicy, MagazineSampling,
                index: NOBODY, show: NATIONAL + %i[regional_role],
                create: NATIONAL, update: NATIONAL, destroy: NOBODY
    assert_scope MagazineSamplingPolicy, all: NATIONAL, nil => ALL - NATIONAL
  end

  test "public data" do
    [ PublicDataPolicy, UrlPolicy, ConcertPolicy ].each do |policy_class|
      assert_crud policy_class, Concert,
                  index: NOBODY, show: ALL, create: ALL,
                  update: NATIONAL + %i[public_data], destroy: NATIONAL + %i[public_data]
    end
  end

  test "homepages" do
    assert_crud HomepagePolicy, Homepage,
                index: NOBODY, show: ALL, create: ALL, update: ADMIN, destroy: ADMIN
  end

  test "admin" do
    assert_permissions AdminPolicy, :admin, %i[index? show?], ADMIN
  end

  test "users" do
    assert_crud UserPolicy, User,
                index: NOBODY, show: NATIONAL + %i[regional_role],
                create: NATIONAL, update: ADMIN, destroy: ADMIN
    assert_permissions UserPolicy, User, :add_role?, ADMIN
    assert_scope UserPolicy, all: NATIONAL, nil => ALL - NATIONAL
  end

  test "bulk mails" do
    assert_permissions BulkPolicy, :bulk, %i[index? show?], %i[admin bulk bulk_notify]
    assert_permissions BulkPolicy, :bulk, %i[create? new? send_mails?], %i[admin bulk]
  end

  test "feature requests" do
    feature_request = Struct.new(:user)
    others_request = feature_request.new(Object.new)
    author = user_for(:plain)
    own_request = feature_request.new(author)

    assert_permissions FeatureRequestPolicy, others_request, %i[show? create?], ALL
    assert_permissions FeatureRequestPolicy, others_request, %i[update? destroy?], ADMIN
    assert FeatureRequestPolicy.new(author, own_request).update?
    assert FeatureRequestPolicy.new(author, own_request).destroy?
    assert_scope FeatureRequestPolicy, all: ALL
  end

  EMPTY_POLICIES = [
    BoardContactPolicy, ClassifiedPolicy, CompetitionEntryPolicy, ComposerPolicy, ContactPolicy,
    ContestPolicy, CoursePolicy, DataFilePolicy, EnsembleConcertPolicy, EnsemblePolicy,
    FestivalApplicationAttachmentPolicy, FestivalPolicy, FunctionPolicy, GenericViewPolicy,
    MagazineAdvertPolicy, RegionalOrganizationBookingPolicy, RolePolicy, UniversityPolicy,
    UploadedFilePolicy, UploadPolicy, UrlCategoryPolicy
  ].freeze

  EMPTY_POLICIES.each do |policy_class|
    test "#{policy_class} denies everything" do
      assert_crud policy_class, :record,
                  index: NOBODY, show: NOBODY, create: NOBODY, update: NOBODY, destroy: NOBODY
    end
  end
end
