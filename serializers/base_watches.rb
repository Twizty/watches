module Serializers
  class BaseWatches
    def serialize
      raise NotImplementedError
    end

    protected

    def parse(str_or_time)
      if str_or_time.is_a?(String)
        Time.at(str_or_time.to_i)
      else
        str_or_time
      end
    end
  end
end
