class UserGroup < ActiveRecord::Base
validates :name, presence: true
 MODULESTOPERMIT = ['gallery','category', 'mediumcategory', 'subjectmatter', 'job','jobcategory', 'package','advertisementpackage','news_category', 'news','newsletter_setting', 'staticpage','advertisement','faq', 'sitesetting', 'tag', 'tutorial','jobskill','categorytype','softwareexpertise', 'user','usergroup','widget','comment','topic','tutorial','message','menu','questionaire','challenge','company','invitation','download','post_type_category','post_type','image_library','video_library','upload_video_library','zip_library','systememail']
  has_one :access_control, dependent: :destroy
  accepts_nested_attributes_for :access_control
 
   def has_permission(action)
#abort(self.is_super_mod)
		if self.is_super_mod == true
		#abort('a')
		  return true
		else
	#	abort('abn')
		  return false unless access_control.present?
		  access_control.permissions_hash.include?(action)
		end
   end
  
end
