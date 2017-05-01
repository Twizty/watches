require_relative './base'

class Store::InMemory < Store::Base
  def initialize
    @state = {}
  end

  def upsert(store, bucket, value)
    init_bucket(store, bucket)
    raise ArgumentError if value.keys.count > Store::MAX_KEYS_COUNT_ALLOWED

    @state["#{store}_#{bucket}"][value.keys.first] = value.values.first
  end

  def fetch(store, bucket, d)
    @state["#{store}_#{bucket}"].select { |_, v| v > d }
  end

  private

  def init_bucket(store, bucket)
    @state["#{store}_#{bucket}"] = {} if @state["#{store}_#{bucket}"].nil?
  end
end
