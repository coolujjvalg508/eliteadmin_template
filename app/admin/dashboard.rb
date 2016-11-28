ActiveAdmin.register_page "Dashboard" do

  menu priority: 1, label: proc{ I18n.t("active_admin.dashboard") }

  content title: proc{ I18n.t("active_admin.dashboard") } do
   columns do
			  column do
					  panel "User Section" do
							ul do
									li do
										span class: 'dash_left' do
											'Admin Users'
										end
										span class: 'dash_right' do
											link_to(AdminUser.count, 'admin_users')
										end
									end
									li do
										span class: 'dash_left' do
											'Front Users'
										end
										span class: 'dash_right' do
											link_to(User.count, 'users')
										end
									end
									li do
										span class: 'dash_left' do
											'User Group'
										end
										span class: 'dash_right' do
											link_to(UserGroup.count, 'user_groups')
										end
									end
							end
					  end
				end
				
				  column do
					  panel "Download Section" do
							ul do
									li do
										span class: 'dash_left' do
											'Total Downloads'
										end
										span class: 'dash_right' do
											link_to(Download.count, 'downloads')
										end
									end
									li do
										span class: 'dash_left' do
											'Category & Subcategory'
										end
										span class: 'dash_right' do
											link_to(PostTypeCategory.count, 'post_type_categories')
										end
									end
									li do
										span class: 'dash_left' do
											'Post Type'
										end
										span class: 'dash_right' do
											link_to(PostType.count, 'post_types')
										end
									end
							end
					  end
				end
				
				 column do
					  panel "Gallery/Projects Section" do
							ul do
									li do
										span class: 'dash_left' do
											'Total Projects'
										end
										span class: 'dash_right' do
											link_to(Gallery.count, 'projects')
										end
									end
									li do
										span class: 'dash_left' do
											'Post Type Category'
										end
										span class: 'dash_right' do
											link_to(Category.count, 'categories')
										end
									end
									li do
										span class: 'dash_left' do
											'Medium Category'
										end
										span class: 'dash_right' do
											link_to(MediumCategory.count, 'medium_categories')
										end
									end
									li do
										span class: 'dash_left' do
											'Subject Matter Category'
										end
										span class: 'dash_right' do
											link_to(SubjectMatter.count, 'subject_matters')
										end
									end
							end
					  end
				end
		 
		  column do
					  panel "Job Section" do
							ul do
									li do
										span class: 'dash_left' do
											'Total Jobs'
										end
										span class: 'dash_right' do
											link_to(Job.count, 'jobs')
										end
									end
									li do
										span class: 'dash_left' do
											'Contract Type'
										end
										span class: 'dash_right' do
											link_to(JobCategory.count, 'contract_types')
										end
									end
									
							end
					  end
				end
				
		end
		
		columns do 
		
			 column do
					  panel "Media Library" do
							ul do
									li do
										span class: 'dash_left' do
											'Total Image'
										end
										span class: 'dash_right' do
											link_to(Image.count, 'images')
										end
									end
									li do
										span class: 'dash_left' do
											'Total Video'
										end
										span class: 'dash_right' do
											link_to(Video.count, 'videos')
										end
									end
									li do
										span class: 'dash_left' do
											'Total Upload Video'
										end
										span class: 'dash_right' do
											link_to(UploadVideo.count, 'upload_videos')
										end
									end
									
							end
					  end
				end
				
				 column do
					  panel "News Section" do
							ul do
									li do
										span class: 'dash_left' do
											'Total News'
										end
										span class: 'dash_right' do
											link_to(News.count, 'news')
										end
									end
									li do
										span class: 'dash_left' do
											'News Category'
										end
										span class: 'dash_right' do
											link_to(NewsCategory.count, 'news_categories')
										end
									end
									
									
							end
					  end
				end
				
				 column do
					  panel "Package Section" do
							ul do
									li do
										span class: 'dash_left' do
											'Total Job Package'
										end
										span class: 'dash_right' do
											link_to(Package.count, 'job_packages')
										end
									end
									li do
										span class: 'dash_left' do
											'Total Advertisement Package'
										end
										span class: 'dash_right' do
											link_to(AdvertisementPackage.count, 'advertisement_packages')
										end
									end
									
									
							end
					  end
				end
				
				
				 column do
					  panel "CMS/Pages Section" do
							ul do
									li do
										span class: 'dash_left' do
											'Static Pages'
										end
										span class: 'dash_right' do
											link_to(StaticPage.count, 'static_pages')
										end
									end
									li do
										span class: 'dash_left' do
											'Total FAQs'
										end
										span class: 'dash_right' do
											link_to(Faq.count, 'faqs')
										end
									end
									
									li do
										span class: 'dash_left' do
											'Total Banners'
										end
										span class: 'dash_right' do
											link_to(Advertisement.count, 'banners')
										end
									end
									
									
							end
					  end
				end
		
		end
		
		columns do 
		
			 column do
					  panel "Tutorial Section" do
							ul do
									li do
										span class: 'dash_left' do
											'Total Tutorials'
										end
										span class: 'dash_right' do
											link_to(Tutorial.count, 'tutorials')
										end
									end
									li do
										span class: 'dash_left' do
											'Total Topics'
										end
										span class: 'dash_right' do
											link_to(Topic.count, 'topics')
										end
									end
								
									
							end
					  end
				end
				
				 column do
					  panel "User Setting Section" do
							ul do
									li do
										span class: 'dash_left' do
											'Total Skills'
										end
										span class: 'dash_right' do
											link_to(JobSkill.count, 'skills')
										end
									end
									li do
										span class: 'dash_left' do
											'Total Positions'
										end
										span class: 'dash_right' do
											link_to(CategoryType.count, 'positions')
										end
									end
									li do
										span class: 'dash_left' do
											'Total Software Expertise'
										end
										span class: 'dash_right' do
											link_to(SoftwareExpertise.count, 'software_expertises')
										end
									end
									
									
							end
					  end
				end
				
				column do
					  panel "Tag Section" do
							ul do
									li do
										span class: 'dash_left' do
											'Total Tags'
										end
										span class: 'dash_right' do
											link_to(Tag.count, 'tags')
										end
									end
							end
					  end
				end
				
				column do
					  panel "Menu Section" do
							ul do
									li do
										span class: 'dash_left' do
											'Total Menus'
										end
										span class: 'dash_right' do
											link_to(Menu.count, 'menus')
										end
									end
							end
					  end
				end
				
				
		
		end
		
		
		
  end
end
