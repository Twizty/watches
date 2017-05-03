require 'json'
require 'redis'

require './app'

RSpec.describe App do
  context 'in memory store' do
    let(:app) { described_class }

    it 'returns 201 when marks video as watched' do
      post '/videos/1/watch', user_id: "1"
      expect(last_response.status).to eq(201)
    end

    it 'returns empty response if bucket is empty' do
      get '/videos/foo_bar/watches'
      expect(last_response.body).to eq '[]'

      get '/users/foo_bar/watches'
      expect(last_response.body).to eq '[]'
    end

    it 'returns 400 if user_id nil' do
      post '/videos/1/watch'
      expect(last_response.status).to eq(400)
      expect(last_response.body).to eq('user_id may not be empty')
    end

    it 'returns 400 if user_id is empty string' do
      post '/videos/1/watch', user_id: ''
      expect(last_response.status).to eq(400)
      expect(last_response.body).to eq('user_id may not be empty')
    end

    it 'response contains watched video' do
      post '/videos/1/watch', user_id: "1"

      get '/videos/1/watches'
      resp = JSON.parse(last_response.body)
      expect(resp.length).to eq 1
      expect(resp.first['user_id']).to eq "1"

      get '/users/1/watches'
      resp = JSON.parse(last_response.body)
      expect(resp.length).to eq 1
      expect(resp.first['video_id']).to eq "1"
    end

    it 'response becomes empty after 5 seconds' do
      post '/videos/1/watch', user_id: "1"

      get '/videos/1/watches'
      expect(last_response.body).not_to eq '[]'

      get '/users/1/watches'
      expect(last_response.body).not_to eq '[]'

      sleep(5)

      get '/videos/1/watches'
      expect(last_response.body).to eq '[]'

      get '/users/1/watches'
      expect(last_response.body).to eq '[]'
    end
  end

  context 'redis store' do
    ENV['USE_REDIS'] = 'true'
    let(:app) { described_class }
    let(:redis) { Redis.new }

    it 'saves data to redis' do
      post '/videos/1/watch', user_id: "1"
      expect(last_response.status).to eq(201)

      timestamp1 = redis.hget("users_watches_1", "1")
      timestamp2 = redis.hget("videos_watches_1", "1")

      expect(timestamp1).to eq timestamp2
      expect { Time.at(timestamp1.to_i) }.not_to raise_error
    end

    it 'gets data from redis' do
      t = Time.now
      redis.hset("users_watches_1", "1", t.to_i.to_s)
      redis.hset("videos_watches_1", "1", t.to_i.to_s)

      get '/videos/1/watches'
      resp = JSON.parse(last_response.body)
      expect(resp.length).to eq 1
      expect(resp.first['user_id']).to eq "1"
      expect(resp.first['updated_at']).to eq t.to_s

      get '/users/1/watches'
      resp = JSON.parse(last_response.body)
      expect(resp.length).to eq 1
      expect(resp.first['video_id']).to eq "1"
      expect(resp.first['updated_at']).to eq t.to_s
    end

    it 'response becomes empth after 5 seconds' do
      t = Time.now
      redis.hset("users_watches_1", "1", t.to_i.to_s)
      redis.hset("videos_watches_1", "1", t.to_i.to_s)

      get '/videos/1/watches'
      expect(last_response.body).not_to eq '[]'

      get '/users/1/watches'
      expect(last_response.body).not_to eq '[]'

      sleep(5)

      get '/videos/1/watches'
      expect(last_response.body).to eq '[]'

      get '/users/1/watches'
      expect(last_response.body).to eq '[]'
    end
  end
end
