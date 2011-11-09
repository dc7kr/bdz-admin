module ApplicationHelper

  def default_page_title
    title + ' - ' + subtitle
  end
  
  def title
    'BDZ Admin Interface'
  end
  
  def subtitle
    ''
  end

def corika_tr(entity,field,default)
    t("activerecord.attributes."+entity+"."+field, :default => t("activerecord.labels."+field, :default => default))
end
def link_back(path, txt)
    link_to image_tag('/images/icons/back.png', {:size=>'16x16',:alt=>txt,:title=>txt,:class=>'btn'} ),path
end

def link_to_edit(path, txt)
#    if user_signed_in?
                link_to image_tag('/images/icons/edit.png', {:size=>'16x16',:alt=>txt,:title=>txt,:class=>'btn'} ),path
#        end
end

def link_to_show(path, txt)
        link_to image_tag('/images/icons/show.png', {:size=>'16x16',:alt=>txt,:title=>txt,:class=>'btn'} ),path
end

def link_to_new(path, txt)
#    if user_signed_in?
          link_to image_tag('/images/icons/new.png', {:size=>'16x16',:alt=>txt,:title=>txt,:class=>'btn'} ),path
#    end
end

def link_to_delete(path, txt, confirm )
#    if user_signed_in?
                link_to image_tag('/images/icons/delete.png', {:size=>'16x16',:alt=>txt,:title=>txt,:class=>'btn'} ),path,:confirm => confirm
#        end
end

end
