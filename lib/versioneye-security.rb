require 'log4r'
require 'log4r/configurator'
require 'mongoid'
require 'httparty'

require 'settings'
require './lib/versioneye/common_security'
require './lib/versioneye/php_sensiolabs_crawler'
require './lib/versioneye/php_magento_crawler'
require './lib/versioneye/node_security_crawler'
require './lib/versioneye/ruby_security_crawler'
require './lib/versioneye/java_security_crawler'
require './lib/versioneye/python_security_crawler'

require './lib/versioneye/producers/producer'
require './lib/versioneye/producers/security_producer'

require './lib/versioneye/workers/worker'
require './lib/versioneye/workers/security_worker'


class VersioneyeSecurity

  def initialize
    puts "initialize ruby_crawl"
    init_logger
    init_mongodb
    init_settings
  end

  def init_logger
    Log4r::Configurator.load_xml_file('config/log4r.xml')
  end

  def init_mongodb
    Mongoid.load!("config/mongoid.yml", Settings.instance.environment)
  end

  def init_settings
    Settings.instance.reload_from_db GlobalSetting.new
  end

end
