require "lemmatizer"

module TextTagger
  class Token

    attr_reader :index
    attr_reader :word
    attr_reader :tag

    LEMMATIZER = Lemmatizer.new

    def initialize(index, word, tag)
      @index = index
      @word = word
      @tag = tag
      @lemma = nil
    end

    # Make lemma lazy (its expensive and not always needed)
    def lemma
      @lemma = LEMMATIZER.lemma(word)
    end

    def to_s
      %Q[<Token:#{@index} word="#{@word}", lemma="#{@lemma}", tag="#{TagDefinition.explain(@tag)}">]
    end

    def readable
      "#{self.word}/#{self.tag.to_s.upcase}"
    end

  end
end


