module TextTagger
  class Unknown < ApplicationRecord

    class ClassifyingHash < Hash 
      def [](word)
        super.send(Unknown.classify(word))
      end

      def fetch(word)
        super.send(Unknown.classify(word))
      end
    end

    def self.eagerload
      data = ClassifyingHash.new
      Unknown.all.each do |unknown|
        data[unknown.key] ||= {}
        data[unknown.key][unknown.tag] = unknown.value
      end
      data
    end

    def self.classify(word)
      return :unknown unless word

      case word.to_s
      when /[\(\{\[]/
        :left_bracket
      when /[\)\}\]]/
        :right_bracket
      when /-?(?:\d+(?:\.\d*)?|\.\d+)\z/ # Floating point number
        :number
      when /\A\d+[\d\/:-]+\d\z/  # Other number constructs
        :number
      when /\A-?\d+\w+\z/o        # Ordinal number
        :ordinal
      when /\A[A-Z][A-Z\.-]*\z/o
        :abbreviation
      when /\w-\w/o             # Hyphenated word
        /-([^-]+)\z/ =~ word
        h_suffix = $1
        if h_suffix && Word.exists?(key: h_suffix, tag: 'jj')
          :hyphen_adjuctive # last part of this is defined as an adjective
        else
          :hyphen    # last part of this is not defined as an adjective
        end
      when /\A\W+\z/o
        :symbol
      when /\A[A-Z][a-z]+\z/
        :capitalized_word
      when /ing\z/o
        :ing_suffix
      when /s\z/o
        :s_suffix
      when /tion\z/o
        :tion_suffix
      when /ly\z/o
        :ly_suffix
      when /ed\z/o
        :ed_suffix
      else
        :unknown 
      end
    end

  end
end
