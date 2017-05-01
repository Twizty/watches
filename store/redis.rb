require 'redis'

require_relative './base'

class Store::Redis < Store::Base
  def upsert(store, bucket, value)
    raise ArgumentError if value.keys.count > Store::MAX_KEYS_COUNT_ALLOWED

    redis.hset("#{store}_#{bucket}", value.keys.first, value.values.first.to_i.to_s)
  end

  def fetch(store, bucket, d)
    redis.hgetall("#{store}_#{bucket}").select { |_, v| d < Time.at(v.to_i) }
  end

  private

  def redis
    @_redis ||= Redis.new
  end
end
