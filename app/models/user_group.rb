class UserGroup < ActiveRecord::Base
validates :name, presence: true
 MODULESTOPERMIT = ['gallery','category', 'mediumcategory', 'subjectmatter', 'job','jobcategory', 'package','advertisementpackage', 'news', 'staticpage','advertisement','faq', 'sitesetting', 'tag', 'tutorial','jobskill','categorytype','softwareexpertise', 'usersetting', 'user','usergroup']
  has_one :access_control, dependent: :destroy
  accepts_nested_attributes_for :access_control
  
   def has_permission(action)
    if self.role == 'super_admin'
      return true
    else
      return false unless access_control.present?
      access_control.permissions_hash.include?(action)
    end
  end
  
  
end
