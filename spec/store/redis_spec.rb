require './store/redis'

RSpec.describe Store::Redis do
  let(:store) { described_class.new }

  context '#upsert' do
    it 'adds to store' do
      t = Time.now
      store.upsert(:users_watches, "1", key: "1", value: t)

      expect(store.send(:redis).hget("users_watches_1", "1")).to eq t.to_i.to_s
    end
  end

  context '#fetch' do
    it 'fetches from store with given filter' do
      t = Time.now
      store.upsert(:users_watches, "1", key: "1", value: t - 2)
      store.upsert(:users_watches, "1", key: "2", value: t + 1)

      sleep(2)

      result = store.fetch(:users_watches, "1", t)
      expect(result).to eq({"2" => (t.to_i + 1).to_s})
    end
  end
end
