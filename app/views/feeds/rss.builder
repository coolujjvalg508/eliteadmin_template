#encoding: UTF-8

xml.instruct! :xml, :version => "1.0"
xml.rss :version => "2.0" do
  xml.channel do
    xml.title "CGMeetup"
    xml.author "Joh Warner"
    xml.description "About the Computer Graphics People Community"
    xml.link root_url
    xml.language "en"

    for post in @posts
      xml.item do
        xml.category 'latest posts'
        xml.title post.title
        xml.link show_gallery_url(post.paramlink)
        xml.guid show_gallery_url(post.paramlink)
        xml.description post.description
        xml.totalLikes post.like_count
        xml.totalComments post.comment_count
        xml.totalViews post.view_count
        xml.author post.user.username
      end
    end

    for job in @jobs
      xml.item do
        xml.category 'jobs'
        xml.title job.title
        xml.link apply_job_url(job.paramlink)
        xml.description job.description
        xml.totalLikes job.like_count
        xml.totalComments job.comment_count
        xml.totalViews job.view_count
        if job.company_name
          xml.company job.company_name
        end
        if job.city
          xml.city job.city
        end
      end
    end

    for download in @downloads
      xml.item do
        xml.category 'donwloads'
        xml.title download.title
        xml.link show_download_url(download.paramlink)
        xml.description download.description
        xml.totalLikes download.like_count
        xml.totalComments download.comment_count
        xml.totalViews download.view_count
      end
    end

    for artist in @artists
      xml.item do
        xml.category 'artists'
        xml.name artist.username
        xml.link artist_profile_url(artist)
        xml.type artist.profile_type
        xml.totalLikes artist.like_count
        xml.totalViews artist.view_count
        xml.totalFollowers artist.follow_count
      end
    end

    for n in @news_behind_scenes
      xml.item do
        xml.category 'benhind the scenes'
        xml.title n.title
        xml.link apply_job_url(n.paramlink)
        xml.description n.description
        xml.totalLikes n.like_count
        xml.totalViews n.view_count

      end
    end

    for n in @news_movies
      xml.item do
        xml.category 'movies'
        xml.title n.title
        xml.link apply_job_url(n.paramlink)
        xml.description n.description
        xml.totalLikes n.like_count
        xml.totalViews n.view_count
      end
    end

    for n in @news_tutorials
      xml.item do
        xml.category 'tutorials'
        xml.title n.title
        xml.link apply_job_url(n.paramlink)
        xml.description n.description
        xml.totalLikes n.like_count
        xml.totalViews n.view_count
      end
    end

    for n in @news_press_data
      xml.item do
        xml.category 'press'
        xml.title n.title
        xml.link apply_job_url(n.paramlink)
        xml.description n.description
        xml.totalLikes n.like_count
        xml.totalViews n.view_count
      end
    end
  end
end
