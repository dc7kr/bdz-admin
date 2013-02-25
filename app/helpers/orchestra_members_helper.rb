module OrchestraMembersHelper

def link_to_exchange(path,txt, entity)
    if can? :update, entity
		link_to image_tag('/assets/icons/exchange.png', {:size=>'16x16',:alt=>txt,:title=>txt,:class=>'btn'} ),{ :id=>entity, :action=>'exchange'}
    end
end


end
