# Application settings that admins change in the web UI (admin menu > runtime options).
#
#   RuntimeOption.festival_year     # => 2026
#   RuntimeOption[:festival_year]   # same
#
# Every option is defined below with a type and a default. Options without a
# database row use the default, which for now comes from config/bdz-settings.yml.
#
# Reading an option doesn't query the database: each process (puma, sidekiq,
# console) keeps all values in memory. The cache is loaded on first use and reloaded
# - right away in the process that saves or resets an option,
# - in every other process when it notices that the table changed. A process checks
#   at most every check_interval seconds with a single COUNT/MAX query,
# - in all processes by RuntimeOption.reload_all! (reload button in the UI), e.g.
#   after rows were changed by SQL.
#
# See docs/runtime_options.md.
class RuntimeOption < ApplicationRecord
  Definition = Data.define(:key, :type, :default) do
    def default_value
      RuntimeOption.cast(type, default.respond_to?(:call) ? default.call : default)
    end
  end

  VALUE_COLUMNS = {
    "string" => "string_value",
    "integer" => "integer_value",
    "boolean" => "bool_value",
    "datetime" => "datetime_value"
  }.freeze

  DEFINITIONS = {}

  def self.option(key, type, default: nil)
    raise ArgumentError, "unknown runtime option type: #{type}" unless VALUE_COLUMNS.key?(type.to_s)

    DEFINITIONS[key.to_s] = Definition.new(key.to_s, type.to_s, default)
    define_singleton_method(key) { self[key] }
  end

  def self.festival_setting(name)
    -> { BDZ_SETTINGS.dig("config", name) if defined?(BDZ_SETTINGS) }
  end

  option :festival_year, :integer, default: festival_setting("festival_year")
  option :festival_application_open, :boolean, default: festival_setting("festival_application_open")
  option :presale_active, :boolean, default: festival_setting("presale_active")
  option :pickup_date, :datetime, default: festival_setting("pickup_date")
  option :festival_email, :string, default: festival_setting("festival_email")

  DEFINITIONS.freeze

  CACHE_LOCK = Mutex.new

  class << self
    def [](key)
      key = key.to_s
      raise KeyError, "unknown runtime option: #{key}" unless DEFINITIONS.key?(key)

      cached_values[key]
    end

    # (re)loads the values of this process from the database
    def reload_cache
      CACHE_LOCK.synchronize { load_cache }
    end

    # makes every process reload: touching the rows changes the version they check
    def reload_all!
      touch_all
      reload_cache
    end

    # seconds between the checks for changes made by other processes
    def check_interval
      Rails.configuration.x.runtime_options.check_interval || 10
    end

    def cast(type, value)
      return false if type == "boolean" and value.nil?
      return if value.nil?

      case type
      when "integer" then Integer(value)
      when "boolean" then ActiveModel::Type::Boolean.new.cast(value)
      when "datetime" then value.is_a?(String) ? Time.zone.parse(value) : value.in_time_zone
      else value.to_s
      end
    end

    private

    def cached_values
      refresh_cache if @values.nil? or stale?
      @values
    end

    def stale?
      Process.clock_gettime(Process::CLOCK_MONOTONIC) - @checked_at >= check_interval
    end

    def refresh_cache
      CACHE_LOCK.synchronize do
        # another thread may have refreshed while this one waited for the lock
        next unless @values.nil? or stale?

        if @values.nil? or table_version != @version
          load_cache
        else
          @checked_at = Process.clock_gettime(Process::CLOCK_MONOTONIC)
        end
      end
    end

    # called with CACHE_LOCK held
    def load_cache
      version = table_version
      stored = where(key: DEFINITIONS.keys).to_h { |option| [ option.key, option.value ] }
      @values = DEFINITIONS.transform_values(&:default_value).merge(stored).freeze
      @version = version
    rescue ActiveRecord::ActiveRecordError => e
      # e.g. table not migrated yet: use the defaults and try again later
      Rails.logger.warn("RuntimeOption: using defaults, loading failed: #{e.message}")
      @values = DEFINITIONS.transform_values(&:default_value).freeze
      @version = nil
    ensure
      @checked_at = Process.clock_gettime(Process::CLOCK_MONOTONIC)
    end

    # changes whenever a row is created, updated, deleted or touched
    def table_version
      unscoped.pick(Arel.sql("COUNT(*)"), Arel.sql("MAX(updated_at)"))
    end
  end

  validates :key, presence: true, uniqueness: true, inclusion: { in: ->(_) { DEFINITIONS.keys } }
  validate :value_present

  before_validation { self.value_type = definition&.type }
  after_commit { self.class.reload_cache }

  def to_param
    key
  end

  def definition
    DEFINITIONS[key]
  end

  def value
    self[VALUE_COLUMNS[value_type]] if value_type
  end

  # assigns a form value, cast by the column of the option's type
  def value=(new_value)
    self.value_type = definition&.type
    raise ArgumentError, "unknown runtime option: #{key}" unless value_type

    VALUE_COLUMNS.each_value { |column| self[column] = nil }
    self[VALUE_COLUMNS[value_type]] = new_value
  end

  # the value used while the option has no database row
  def default_value
    definition&.default_value
  end

  private

  def value_present
    errors.add(:value, :blank) if definition and value.nil?
  end
end
