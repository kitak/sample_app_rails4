# Be sure to restart your server when you modify this file.

SampleApp::Application.config.session_store ActionDispatch::Session::CacheStore, :expire_after => 3.day 
