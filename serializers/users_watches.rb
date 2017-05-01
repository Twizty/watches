require 'json'

require_relative './base_watches'

class Serializers::UsersWatches < Serializers::BaseWatches
  def initialize(users)
    @users = users
  end

  def serialize
    @users.map { |k, v| { user_id: k, updated_at: parse(v) } }.to_json
  end
end
