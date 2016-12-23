Rails.application.configure do
  # Settings specified here will take precedence over those in config/application.rb.

  # In the development environment your application's code is reloaded on
  # every request. This slows down response time but is perfect for development
  # since you don't have to restart the web server when you make code changes.
  config.cache_classes = false
  config.action_mailer.default_url_options ={ host: ENV["SMTP_HOST"] }
  
  # Do not eager load code on boot.
  config.eager_load = false
  
   config.time_zone = 'UTC'
  config.active_record.default_timezone = :utc


  # Show full error reports and disable caching.
  config.consider_all_requests_local       = true
  config.action_controller.perform_caching = false

  # Don't care if the mailer can't send.
  config.action_mailer.raise_delivery_errors = false

  # Print deprecation notices to the Rails logger.
  config.active_support.deprecation = :log

  # Raise an error on page load if there are pending migrations.
  config.active_record.migration_error = :page_load

  config.assets.debug = true
  config.assets.digest = true
   config.action_mailer.asset_host = ENV["SMTP_HOST"]
  config.action_mailer.delivery_method = :smtp
  config.action_mailer.smtp_settings = {
    #Enter the smtp provider here ex: smtp.mandrillapp.com
    address: ENV["SMTP_ADDRESS"],
    port: 587,
    #Enter the smtp domain here ex: localhost:3000
    domain: ENV["SMTP_DOMAIN"],
    #Enter the user name for smtp provider here
    user_name: ENV["SMTP_USERNAME"],
    #Enter the password for smtp provider here
    password: ENV["SMTP_PASSWORD"],
    authentication: 'plain',
    enable_starttls_auto: true
  }


  # Raises error for missing translations
  # config.action_view.raise_on_missing_translations = true
end
