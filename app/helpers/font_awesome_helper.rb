module FontAwesomeHelper
  def my_fa_icon(name, fa_class = "fas")
    #= icon('fa-solid', name)
    tag.i class: [ fa_class, "fa-#{name}" ]
  end
end
