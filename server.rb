require 'sinatra'
require 'dry-auto_inject'

require './container'
require './serializers/users_watches'
require './serializers/videos_watches'

Import = Dry::AutoInject(Container)

class App < Sinatra::Base
  include Import[:store]

  STATUS_CREATED = 201
  TIMEOUT = 5

  post '/videos/:id/watch' do
    video_id = params[:id]
    user_id  = params[:user_id]
    t = Time.now

    store.upsert(:users_watches, user_id, video_id => t)
    store.upsert(:videos_watches, video_id, user_id => t)

    status STATUS_CREATED
    body nil
  end

  get '/users/:id/watches' do
    content_type :json
    user_id  = params[:id]

    result = store.fetch(:users_watches, user_id, Time.now - TIMEOUT)
    Serializers::UsersWatches.new(result).serialize
  end

  get '/videos/:id/watches' do
    content_type :json
    video_id = params[:id]

    result = store.fetch(:videos_watches, video_id, Time.now - TIMEOUT)
    Serializers::VideosWatches.new(result).serialize
  end
end
