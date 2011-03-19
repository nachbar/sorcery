require File.join(File.dirname(__FILE__), '..', 'myapp.rb')
$: << APP_ROOT # for model reloading

require 'rack/test'
require 'rspec'

set :environment, :test

module RSpecMixinExample
  include Rack::Test::Methods
  def app
    Sinatra::Application
  end
end

Rspec.configure do |config|
  config.send(:include, RSpecMixinExample)
  
  config.before(:suite) do
    ActiveRecord::Migrator.migrate("#{APP_ROOT}/db/migrate/core")
  end

  config.after(:suite) do
    ActiveRecord::Migrator.rollback("#{APP_ROOT}/db/migrate/core")
  end
  
end

# needed when running individual specs
require File.join(File.dirname(__FILE__), '..','user')
require File.join(File.dirname(__FILE__), '..','authentication')

class TestUser < ActiveRecord::Base
  activate_sorcery!
end

class TestMailer < ActionMailer::Base

end

include ::Sorcery::TestHelpers
include ::Sorcery::TestHelpers::Sinatra