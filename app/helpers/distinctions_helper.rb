module DistinctionsHelper

def link_to_generate_path(txt,path)
	link_to image_tag('/assets/icons/new.png', {:size=>'16x16',:alt=>txt,:title=>txt,:class=>'btn'} ),path
end


end
