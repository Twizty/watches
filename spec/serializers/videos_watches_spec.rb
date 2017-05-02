require './serializers/videos_watches'

RSpec.describe Serializers::VideosWatches do
  it 'serializes list with datetimes' do
    t = Time.now
    result = Serializers::VideosWatches.new({ "1" => t }).serialize
    expect(result).to eq('[{"video_id":"1","updated_at":"' + t.to_s + '"}]')
  end

  it 'serializes list with strings' do
    t = Time.now
    result = Serializers::VideosWatches.new({ "1" => t.to_i.to_s }).serialize
    expect(result).to eq('[{"video_id":"1","updated_at":"' + t.to_s + '"}]')
  end
end
