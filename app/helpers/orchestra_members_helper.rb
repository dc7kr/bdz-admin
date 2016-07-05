module OrchestraMembersHelper

def link_to_exchange(path,txt, entity)
    if can? :update, entity
      link_to content_tag(:span,"",:class=>"glyphicon glyphicon-transfer"),{ :id=>entity, :action=>'exchange' },:class =>"btn btn-xs btn-default"
    end
end


end
