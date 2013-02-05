require "rubygems"
require "bundler/setup"
require "resque"
require "./reindexer"
require "resque/server"
require "geminabox"

config = File.open(File.join(File.dirname(__FILE__), 'config', 'config.yml')) { |f| f.read }
yaml = YAML::load(config)

Resque.redis = yaml['redis']['server']
Resque.redis.namespace = yaml['redis']['namespace']
Geminabox.data = yaml['gems']['data_directory']
