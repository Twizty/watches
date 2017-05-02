require './store/in_memory'

RSpec.describe Store::InMemory do
  let(:store) { described_class.new }

  context '#upsert' do
    it 'adds to store' do
      t = Time.now
      store.upsert(:users_watches, "1", key: "1", value: t)

      expect(store.instance_variable_get(:@state)).to eq({ users_watches: { "1" => { "1" => t } }})
    end
  end

  context '#fetch' do
    it 'fetches from store with given filter' do
      t = Time.now
      store.upsert(:users_watches, "1", key: "1", value: t - 2)
      store.upsert(:users_watches, "1", key: "2", value: t + 1)

      sleep(2)

      result = store.fetch(:users_watches, "1", t)
      expect(result).to eq({"2" => t + 1})
    end
  end
end
