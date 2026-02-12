module OrchestraMembersHelper
  def link_to_exchange(_path, _txt, entity)
    return unless policy(entity).update?

    link_to _path, class: "btn btn-secondary btn-sm" do
      my_fa_icon("exchange-alt")
    end
  end
end
