ActiveAdmin.register Video do

	menu label: 'Videos', parent: 'Media Library',priority: 2 
	actions :all, except: [:new, :create]
	# See permitted parameters documentation:
	# https://github.com/activeadmin/activeadmin/blob/master/docs/2-resource-customization.md#setting-up-strong-parameters
	#
	# permit_params :list, :of, :attributes, :on, :model
	#
	# or
	#
	# permit_params do
	#   permitted = [:permitted, :attributes]
	#   permitted << :other if params[:action] == 'create' && current_user.admin?
	#   permitted
	# end

	permit_params :video,:caption_video

	index :download_links => ['csv'] do
		   selectable_column
		   column 'Video' do |img|
		   		if(img.video.include?('youtube'))	
						if img.video[/youtu\.be\/([^\?]*)/]
							youtube_id = $1
						  else
							img.video[/^.*((v\/)|(embed\/)|(watch\?))\??v?=?([^\&\?]*).*/]
							youtube_id = $5
						  end
						raw('<iframe title="Video" width="150" height="100" src="https://www.youtube.com/embed/' + youtube_id + '" frameborder="0" allowfullscreen></iframe>')

				 elsif(img.video.include?('vimeo'))	
							match = img.video.match(/https?:\/\/(?:[\w]+\.)*vimeo\.com(?:[\/\w]*\/?)?\/(?<id>[0-9]+)[^\s]*/)

							if match.present?
								vimeoid	=	match[:id]
							end
							raw('<iframe width="150" height="100" src="https://player.vimeo.com/video/'+vimeoid+'" width="640" height="270" frameborder="0" webkitallowfullscreen mozallowfullscreen allowfullscreen></iframe>')
			
				  elsif(img.video.include?('dailymotion'))	
							match =  img.video.gsub('http://www.dailymotion.com/video/', "")
							match1	= match.index('_')
							match	= match[0...match1]
							if match.present?
								dailymotionid	=	match
							end	
					
						raw('<iframe width="150" height="100" frameborder="0"  src="//www.dailymotion.com/embed/video/'+ dailymotionid +'" allowfullscreen></iframe>')	
			
				  end
		   end
		   column 'Videoable Type' do |itype|
			 itype.videoable_type
		   end
		   column 'Caption Video' do |itype|
			 itype.caption_video
		   end
		 
		   actions
	  end

 filter :videoable_type

    form multipart: true do |f|
		
		f.inputs "Video" do
		  f.input :video
		  f.input :caption_video,label:'Caption'
		 
		end
		
		f.actions
    end
    
   	show do
		attributes_table do
		  row :video do |img|
				if(img.video.include?('youtube'))	
						if img.video[/youtu\.be\/([^\?]*)/]
							youtube_id = $1
						  else
							img.video[/^.*((v\/)|(embed\/)|(watch\?))\??v?=?([^\&\?]*).*/]
							youtube_id = $5
						  end
						raw('<iframe title="Gallery Video" width="150" height="100" src="https://www.youtube.com/embed/' + youtube_id + '" frameborder="0" allowfullscreen></iframe>')

				 elsif(img.video.include?('vimeo'))	
							match = img.video.match(/https?:\/\/(?:[\w]+\.)*vimeo\.com(?:[\/\w]*\/?)?\/(?<id>[0-9]+)[^\s]*/)

							if match.present?
								vimeoid	=	match[:id]
							end
							raw('<iframe width="150" height="100" src="https://player.vimeo.com/video/'+vimeoid+'" width="640" height="270" frameborder="0" webkitallowfullscreen mozallowfullscreen allowfullscreen></iframe>')
			
				  elsif(img.video.include?('dailymotion'))	
							match =  img.video.gsub('http://www.dailymotion.com/video/', "")
							match1	= match.index('_')
							match	= match[0...match1]
							if match.present?
								dailymotionid	=	match
							end	
					
						raw('<iframe width="150" height="100" frameborder="0"  src="//www.dailymotion.com/embed/video/'+ dailymotionid +'" allowfullscreen></iframe>')	
			
				  end
		  end
		  row :caption_video
		  row :created_at
		end
    end



end
