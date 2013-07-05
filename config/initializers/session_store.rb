# Be sure to restart your server when you modify this file.
require 'action_dispatch/middleware/session/dalli_store'
Rails.application.config.session_store :dalli_store, :memcache_server => '127.0.0.1:11211', :namespace => 'sessions', :key => '_foundation_session', :expire_after => 3.days
