module Store
  class Base
    def upsert(store, bucket, value)
      raise NotImplementedError
    end

    def fetch(store, bucket)
      raise NotImplementedError
    end
  end
end
