# Set the host name for URL creation
SitemapGenerator::Sitemap.default_host = ENV['HOST_URL']
SitemapGenerator::Sitemap.compress = false
SitemapGenerator::Sitemap.create do
  add '/gallery'
  add '/news'
  add '/downloads'
  add '/tutorials'
  add '/jobs'
  add '/contest'
  add('/', images: Image.sitemap_images)
  add('/', videos: UploadVideo.sitemap_videos + Video.sitemap_videos )
end
