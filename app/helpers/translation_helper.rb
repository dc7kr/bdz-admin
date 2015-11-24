module TranslationHelper
  def t_label(id) 
    I18n.t("helpers.label."+id)
  end
end
