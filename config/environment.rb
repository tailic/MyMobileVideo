# Load the rails application
require File.expand_path('../application', __FILE__)

# Initialize the rails application
Service::Application.initialize!


Sass::Plugin.options[:debug_info] = true
