# Be sure to restart your server when you modify this file.
if Rails.env.production?
  SampleApp::Application.config.session_store ActionDispatch::Session::CacheStore, :expire_after => 3.day 
else
  SampleApp::Application.config.session_store :cookie_store, key: '_sample_app_session' 
end
