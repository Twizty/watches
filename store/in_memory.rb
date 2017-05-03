require_relative './base'

class Store::InMemory < Store::Base
  def initialize
    @state = {}
  end

  def upsert(store, bucket, key:, value:)
    init_bucket(store, bucket)
    @state[store][bucket][key] = value
  end

  def fetch(store, bucket, d)
    init_bucket(store, bucket)
    @state[store][bucket].select { |_, v| v > d }
  end

  private

  def init_bucket(store, bucket)
    @state[store] = {} if @state[store].nil?
    @state[store][bucket] = {} if @state[store][bucket].nil?
  end
end
