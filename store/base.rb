module Store
  EXCLUDE_SEARCH_FIELDS = [:updated_at]
  MAX_KEYS_COUNT_ALLOWED = 1

  class Base
    def upsert(store, bucket, value)
      raise NotImplementedError
    end

    def fetch(store, bucket)
      raise NotImplementedError
    end
  end
end
