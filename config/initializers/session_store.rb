# Be sure to restart your server when you modify this file.
if Rails.env.production?
  require 'action_dispatch/middleware/session/dalli_store'
  if Rails.env.production? && Socket.gethostname !== "app001.kitak.pb"
    Rails.application.config.session_store :dalli_store, :memcache_server => 'app001.kitak.pb:11211', :namespace => 'sessions', :key => '_foundation_session', :expire_after => 3.days
  else
    Rails.application.config.session_store :dalli_store, :memcache_server => '127.0.0.1:11211', :namespace => 'sessions', :key => '_foundation_session', :expire_after => 3.days
  end
else
  SampleApp::Application.config.session_store :cookie_store, key: '_sample_app_session' 
end
