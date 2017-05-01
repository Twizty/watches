require 'json'

require_relative './base_watches'

class Serializers::VideosWatches < Serializers::BaseWatches
  def initialize(videos)
    @videos = videos
  end

  def serialize
    @videos.map { |k, v| { video_id: k, updated_at: parse(v) } }.to_json
  end
end
