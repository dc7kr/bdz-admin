require "test_helper"

class RuntimeOptionTest < ActiveSupport::TestCase
  setup { RuntimeOption.reload_cache }

  test "options without database row use the defaults from bdz-settings.yml" do
    assert_equal BDZ_SETTINGS["config"]["festival_year"], RuntimeOption.festival_year
    assert_equal BDZ_SETTINGS["config"]["festival_email"], RuntimeOption[:festival_email]
    assert_equal Time.zone.parse(BDZ_SETTINGS["config"]["pickup_date"]), RuntimeOption.pickup_date
    assert_equal false, RuntimeOption.presale_active
  end

  test "stored values override the defaults" do
    RuntimeOption.create!(key: "festival_year", value: "2030")
    RuntimeOption.create!(key: "festival_application_open", value: "0")
    RuntimeOption.create!(key: "pickup_date", value: "2030-05-01T10:00")

    assert_equal 2030, RuntimeOption.festival_year
    assert_equal false, RuntimeOption.festival_application_open
    assert_equal Time.zone.local(2030, 5, 1, 10), RuntimeOption.pickup_date
  end

  test "reads are served from the cache" do
    RuntimeOption.festival_year
    assert_no_queries { RuntimeOption.festival_year }
  end

  test "the cache is reloaded when the option is saved or reset" do
    option = RuntimeOption.create!(key: "festival_year", value: 2030)
    option.update!(value: 2031)
    assert_equal 2031, RuntimeOption.festival_year

    option.destroy!
    assert_equal BDZ_SETTINGS["config"]["festival_year"], RuntimeOption.festival_year
  end

  test "changes by other processes are noticed after the check interval" do
    option = RuntimeOption.create!(key: "festival_year", value: 2030)
    # like another process: no callbacks in this one
    option.update_columns(integer_value: 2040, updated_at: 1.minute.from_now)

    Rails.configuration.x.runtime_options.stub(:check_interval, 1.hour) do
      assert_equal 2030, RuntimeOption.festival_year
    end
    assert_equal 2040, RuntimeOption.festival_year
  end

  test "reload_all! makes every process reload" do
    option = RuntimeOption.create!(key: "festival_year", value: 2030)
    RuntimeOption.where(id: option.id).update_all(integer_value: 2040)

    assert_changes -> { RuntimeOption.maximum(:updated_at) } do
      RuntimeOption.reload_all!
    end
    assert_equal 2040, RuntimeOption.festival_year
  end

  test "only defined options with a value can be stored" do
    assert_not RuntimeOption.new(key: "unknown").valid?
    assert_raises(ArgumentError) { RuntimeOption.new(key: "unknown").value = 1 }
    assert_raises(KeyError) { RuntimeOption[:unknown] }

    option = RuntimeOption.new(key: "festival_year", value: "")
    assert_not option.valid?
    assert option.errors.added?(:value, :blank)
  end
end
