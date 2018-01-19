module TextTagger
  class Context < ApplicationRecord

    class DbMemoizingHash < Hash
      def initialize()
        @memoized = {}
      end

      def [](key)
        fetch(key)
      end

      def fetch(key)
        if !@memoized[key]
          @memoized[key] = Hash.new
          @memoized[key].default = 0.00001 
          Context.where(key: key).each do |context|
            @memoized[key][context.tag] = context.value
          end
        end
        @memoized[key]
      end
    end

    def self.eagerload
      DbMemoizingHash.new
    end
  end
end
