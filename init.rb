ROOT_DIR = File.expand_path(File.dirname(__FILE__)) unless defined? ROOT_DIR

require "rubygems"

begin
  require "vendor/dependencies/lib/dependencies"
rescue LoadError
  require "dependencies"
end

require "monk/glue"
require "couchrest"
require "haml"
require "sass"
require "json"
require 'digest/sha2'
require 'pusher'


class Main < Monk::Glue
  set :app_file, __FILE__
  use Rack::Session::Cookie
end

# Connect to couchdb.
couchdb_url = monk_settings(:couchdb)[:url]
COUCHDB_SERVER = CouchRest.database!(couchdb_url)

#set up push notifications
Pusher.app_id = '1502'
Pusher.key = '1231959769d3387d5565'
Pusher.secret = '17702481847af120a02e'


# Load all application files.
Dir[root_path("app/**/*.rb")].each do |file|
  require file
end

Main.run! if Main.run?
