#!/usr/bin/ruby -Ku

require 'active_record'

ActiveRecord::Base.establish_connection(
  :adapter => 'postgresql',
  :host => 'localhost',
  :username => 'twitter_response_watcher',
  :password => 'twitter_response_watcher',
  :database => 'twitter-response-watcher'
)

class User < ActiveRecord::Base
  has_many :user_infos
end

class UserInfo < ActiveRecord::Base
  belongs_to :users
end
