# frozen_string_literal: true
ENV['NO_RELOAD'] ||= 'true'

require 'rubygems'
require 'bundler/setup'
require 'telegram/bot'
require 'active_record'
require 'logger'
require 'pg'
require 'i18n'
require 'unicode'
require 'yaml'
require 'logger'
require 'digest/sha1'
require 'date'
require 'redis'
require 'concurrent'
require 'active_support/all'
# require 'pry'

APP_ROOT        = File.expand_path('../../', __FILE__)
LIB_PATH        = File.join(APP_ROOT, 'lib')
CONFIG_PATH     = File.join(APP_ROOT, 'config')
MIGRATIONS_PATH = File.join(APP_ROOT, 'db', 'migrations')

Dir[File.join(APP_ROOT, 'app', '*')].each do |dir|
  ActiveSupport::Dependencies.autoload_paths << dir
end

ActiveSupport::Dependencies.autoload_paths << LIB_PATH

connection_details = YAML.load(File.open(File.join(CONFIG_PATH, 'database.yml')))

ActiveRecord::Base.establish_connection(connection_details)
