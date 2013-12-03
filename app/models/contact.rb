class Contact < ActiveRecord::Base

  acts_as_superclass

  def to_s
    first_name+" "+last_name
  end

  def fullname
     result =''
     if ( first_name ) 
      result = result + first_name + ' '
     end
     if (last_name) 
      result = result + last_name
     end
     return result
  end
end
