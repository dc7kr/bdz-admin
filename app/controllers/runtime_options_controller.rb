# Admin UI for RuntimeOption. The options are defined in code, so there is no
# create: editing an option without database row creates it, destroy resets the
# option to its default.
class RuntimeOptionsController < AuthenticatedController
  before_action :set_runtime_option, only: %i[edit update destroy]

  # GET /runtime_options
  def index
    authorize RuntimeOption
    stored = policy_scope(RuntimeOption).index_by(&:key)
    @runtime_options = RuntimeOption::DEFINITIONS.keys.map { |key| stored[key] || RuntimeOption.new(key: key) }
  end

  # GET /runtime_options/festival_year/edit
  def edit
  end

  # PATCH /runtime_options/festival_year
  def update
    @runtime_option.value = params.require(:runtime_option)[:value]

    if @runtime_option.save
      redirect_to runtime_options_path, notice: t("runtime_option.update_success", name: option_name), status: :see_other
    else
      render :edit, status: :unprocessable_entity
    end
  end

  # DELETE /runtime_options/festival_year
  def destroy
    @runtime_option.destroy! if @runtime_option.persisted?

    redirect_to runtime_options_path, notice: t("runtime_option.reset_success", name: option_name), status: :see_other
  end

  # POST /runtime_options/reload
  def reload
    authorize RuntimeOption
    RuntimeOption.reload_all!

    redirect_to runtime_options_path, notice: t("runtime_option.reload_success"), status: :see_other
  end

  private

  def set_runtime_option
    key = params[:key]
    raise ActiveRecord::RecordNotFound, "unknown runtime option: #{key}" unless RuntimeOption::DEFINITIONS.key?(key)

    @runtime_option = policy_scope(RuntimeOption).find_or_initialize_by(key: key)
    authorize @runtime_option
  end

  def option_name
    t("runtime_option.options.#{@runtime_option.key}.name")
  end
end
