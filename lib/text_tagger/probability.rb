module TextTagger
  class Probability < ApplicationRecord

    def self.eagerload(words)
      data = {}
      
      words.each do |word|
        data[word] = Hash.new
        data[word].default = 1.0
      end

      Probability.where(key: words).each do |word|
        data[word.key][word.tag] = word.value
      end

      data
    end

  end
end
