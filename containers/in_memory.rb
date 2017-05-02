require 'dry-container'

require './store/in_memory'

module Containers
  class InMemory
    extend Dry::Container::Mixin

    register :store do
      Store::InMemory.new
    end
  end
end
