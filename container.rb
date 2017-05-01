require 'dry-container'

require './store/in_memory'
require './store/redis'

class Container
  extend Dry::Container::Mixin

  register :store do
    # Store::InMemory.new
    Store::Redis.new
  end
end
