module AdsForPages
	extend ActiveSupport::Concern

	included do
		def get_ads(page_name)
			field = ''
			case page_name
			when "home"
				field = :show_on_home_page
			when "news"
				field = :show_on_news_page
			when "downloads"
				field = :show_on_downloads_page
			when "tutorials"
				field = :show_on_tutorials_page
			when "jobs"
				field = :show_on_jobs_page
			when "jobs_list"
				field = :show_on_jobs_list_page
			when "galleries"
				field = :show_on_galleries_page
			when "jobs_map"
				field = :show_on_jobs_map_page
			when "companies_map"
				field = :show_on_companies_map_page
			when "followers"
				field = :show_on_followers_page
			when "following"
				field = :show_on_followings_page
			end

			ad_data = Widget.where(field => true).select(:id,:section_name, :position, :ad_code)
			@header_ads = filter_by_section(ad_data, "header")
			@body_ads = filter_by_section(ad_data, "body")
			@footer_ads = filter_by_section(ad_data, "footer")

		end

		def filter_by_section(data, name)
			result = {}
			data.select{|d| d.section_name == name}.each{|i| result[i.position.to_sym] = i.ad_code}
			result
		end
	end
end
