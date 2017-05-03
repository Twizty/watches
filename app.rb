require 'sinatra'
require 'dry-auto_inject'

require './containers/in_memory'
require './containers/redis'
require './serializers/users_watches'
require './serializers/videos_watches'

Import = Dry::AutoInject(ENV['USE_REDIS'] == 'true' ? Containers::Redis : Containers::InMemory)

class App < Sinatra::Base
  include Import[:store]

  STATUS_CREATED = 201
  STATUS_BAD_REQUEST = 400

  TIMEOUT = 5

  post '/videos/:id/watch' do
    user_id  = params[:user_id]

    if user_id.nil?
      status STATUS_BAD_REQUEST
      body nil
      return
    end

    video_id = params[:id]
    t = Time.now

    store.upsert(:users_watches, user_id, key: video_id, value: t)
    store.upsert(:videos_watches, video_id, key: user_id, value: t)

    status STATUS_CREATED
    body nil
  end

  get '/users/:id/watches' do
    content_type :json
    user_id  = params[:id]

    result = store.fetch(:users_watches, user_id, Time.now - TIMEOUT)
    Serializers::VideosWatches.new(result).serialize
  end

  get '/videos/:id/watches' do
    content_type :json
    video_id = params[:id]

    result = store.fetch(:videos_watches, video_id, Time.now - TIMEOUT)
    Serializers::UsersWatches.new(result).serialize
  end
end
