require 'redis'
require 'yaml'

require_relative './base'

class Store::Redis < Store::Base
  CONFIG_PATH = './configs/redis.yml'

  def upsert(store, bucket, key:, value:)
    redis.hset("#{store}_#{bucket}", key, value.to_i.to_s)
  end

  def fetch(store, bucket, d)
    redis.hgetall("#{store}_#{bucket}").select { |_, v| d < Time.at(v.to_i) }
  end

  private

  def redis
    @_redis ||= Redis.new(config)
  end

  def config
    @_config ||=
      YAML.load_file(CONFIG_PATH)[ENV['RACK_ENV']].inject({}) { |mem, (k, v)| mem[k.to_sym] = v; mem }
  end
end
