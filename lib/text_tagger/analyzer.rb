module TextTagger

  class Analyzer

    def initialize(text)
      @text = text
      splitter = Splitter.new(@text)
      @parsed = splitter.parse
      @probability = Probability.eagerload(parsed)
      @unknown = Unknown.eagerload
      @context = Context.eagerload
      @tokens = []
      tokenize_text
    end

    def tokens
      @tokens
    end

    def words
      @tokens.map(&:word)
    end

    def tags
      @tokens.map(&:tag)
    end

    def readable
      @tokens.map(&:readable)
    end

    def xml
      # Todo
    end

    def phrases
      bounds = [:prep, :det, :num]
      phrases = @tokens.chunk { |token| bounds.include?(token.tag) }
      phrases.reject! { |phrase| false }
    end

    private

    def tokenize_text
      tag = Config.initial_tag || :pp
      @parsed.each_with_index do |word, index|
        next if word.strip.size == 0
        tag = tag_word(tag, word) 
        @tokens << Token.new(index, word, tag)
      end
    end

    def tag_word(previous_tag, word)
      # tagging depends on the context of the previous tag
      return Tags[:sym] if word == "-sym-"

      probability = @probability[word] || @unknown[word]
      context = @context[previous_tag]

      best_tag = nil
      best_tag_weight = 0.0
      [*probability].each do |tag, probability_weight|
        weight = ( probability_weight.to_f * context[tag].to_f )

        if weight > best_tag_weight
          best_tag_weight = weight
          best_tag = tag
        end
      end

      best_tag.to_s.upcase.to_sym
    end

    def filter_tokens(tags)
      tags = [*tags]
      @tokens.select { |t| tags.include?(t.tag) }
    end

    FILTERS = {
      nouns: [:nn, :nns, :nnp, :nnps],
      proper_nouns: [:nnp, :nnps],
      verbs: [:vb, :vbd, :vbg, :part, :vbp, :vbz],
      infinitive_verbs: [:vb],
      past_tense_verbs: [:vbd],
      gerund_verbs: [:vbg],
      passive_verbs: [:part],
      base_present_verbs: [:vbp],
      present_verbs: [:vbz],
      adjectives: [:jj],
      comparative_adjectives: [:jjr],
      superlative_adjectives: [:jjs],
      adverbs: [:rb, :rbr, :rbs, :rp],
      interrogatives: [:wrb, :wdt, :wp, :wps],
      question_parts: [:wrb, :wdt, :wp, :wps],
      conjunctions: [:cc, :in],
    }.freeze

    FILTERS.each do |name, tags|
      class_eval %Q[def #{name}; filter_tokens(%i{#{tags.map(&:to_s).join(' ')}}); end]
    end

  end

end
