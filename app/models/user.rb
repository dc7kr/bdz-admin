require 'set'

class User < ActiveRecord::Base

  # Include default devise modules. Others available are:
  # :token_authenticatable, :encryptable, :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable
 

  # Setup accessible (or protected) attributes for your model
  attr_accessible :email, :password, :password_confirmation, :remember_me

  ROLES = %w[admin regional national personal]

  def admin?
	admins = [ 
		'karsten.richter@bdz-online.de' ,
	'eckhard.richter@bdz-online.de' ,
	'dominik.hackner@bdz-online.de' ,
	'thomas.kronenberger@bdz-online.de' ,
	'christian.weyhofen@bdz-online.de' ,
	'theresa.brandt@bdz-online.de']
	return admins.member?(self.email)

#	return self.email =='karsten.richter@bdz-online.de' ||
#		self.email=='eckhard.richter@bdz-online.de' ||
#		self.email=='dominik.hackner@bdz-online.de' ||
#		self.email=='thomas.kronenberger@bdz-online.de' ||
#		self.email=='christian.weyhofen@bdz-online.de' ||
#		self.email=='theresa.brandt@bdz-online.de'
  end

end
