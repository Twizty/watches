require 'redis'

require_relative './base'

class Store::Redis < Store::Base
  DB_NAME = 'videos_watches_app'

  def upsert(store, bucket, key:, value:)
    redis.hset("#{store}_#{bucket}", key, value.to_i.to_s)
  end

  def fetch(store, bucket, d)
    redis.hgetall("#{store}_#{bucket}").select { |_, v| d < Time.at(v.to_i) }
  end

  private

  def redis
    @_redis ||= Redis.new(db: DB_NAME)
  end
end
