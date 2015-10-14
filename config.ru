require 'rubygems'
require 'bundler'
require 'autoprefixer-rails'

Bundler.require(:default, ENV['RACK_ENV'])

map '/assets' do
  sprockets = Sprockets::Environment.new
  sprockets.append_path 'assets/stylesheets'
  sprockets.append_path 'assets/images'
  sprockets.append_path 'assets/javascripts'
  run sprockets

  AutoprefixerRails.install(sprockets)
end

require './app'
run App
