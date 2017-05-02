require 'dry-container'

require './store/redis'

module Containers
  class Redis
    extend Dry::Container::Mixin

    register :store do
      Store::Redis.new
    end
  end
end
