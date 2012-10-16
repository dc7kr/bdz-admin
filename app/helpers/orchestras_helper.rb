module OrchestrasHelper

	def link_to_orchestra_acct(orchestra, txt) 
    	if can? :update, orchestra
                link_to image_tag('/assets/icons/account.png', {:size=>'16x16',:alt=>txt,:title=>txt,:class=>'btn'} ),orchestra_member_account_bookings_url(orchestra)

    	end
	end
end
