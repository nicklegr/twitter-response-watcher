#!ruby -Ku

TARGET_ACCOUNTS = %w!nicklegr 1000favs_RT 1000favs 100favs_RT 100favs!

require 'pp'
require 'twitter'
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

TARGET_ACCOUNTS.each do |screen_name|
  user_data = Twitter.user(screen_name)

  user = User.find(:first, :conditions => ['user_id = ?', user_data.id])
  if user
    user.screen_name = screen_name
    user.save!
  else
    user = User.create(:user_id => user_data.id, :screen_name => user_data.screen_name)
  end

  user.user_infos << UserInfo.create(
    :friends_count => user_data.friends_count,
    :followers_count => user_data.followers_count,
    :statuses_count => user_data.statuses_count,
    :listed_count => user_data.listed_count,
  )
end
