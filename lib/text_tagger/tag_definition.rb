module TextTagger
  class TagDefinition

    # This is a constant table lookup, using SQL would be expensive and add no value

    DATA = {
      cc: "Conjunction, coordinating",
      cd: "Adjective, cardinal number",
      det: "Determiner",
      ex: "Pronoun, existential there",
      fw: "Foreign words",
      in: "Preposition / Conjunction",
      jj: "Adjective",
      jjr: "Adjective, comparative",
      jjs: "Adjective, superlative",
      ls: "Symbol, list item",
      md: "Verb, modal",
      nn: "Noun",
      nnp: "Noun, proper",
      nnps: "Noun, proper, plural",
      nns: "Noun, plural",
      pdt: "Determiner, prequalifier",
      pos: "Possessive",
      prp: "Determiner, possessive second",
      prps: "Determiner, possessive",
      rb: "Adverb",
      rbr: "Adverb, comparative",
      rbs: "Adverb, superlative",
      rp: "Adverb, particle",
      sym: "Symbol",
      to: "Preposition",
      uh: "Interjection",
      vb: "Verb, infinitive",
      vbd: "Verb, past tense",
      vbg: "Verb, gerund",
      vbn: "Verb, past/passive participle",
      vbp: "Verb, base present form",
      vbz: "Verb, present 3SG -s form",
      wdt: "Determiner, question",
      wp: "Pronoun, question",
      wps: "Determiner, possessive & question",
      wrb: "Adverb, question",
      pp: "Punctuation, sentence ender",
      ppc: "Punctuation, comma",
      ppd: "Punctuation, dollar sign",
      ppl: "Punctuation, quotation mark left",
      ppr: "Punctuation, quotation mark right",
      pps: "Punctuation, colon, semicolon, elipsis",
      lrb: "Punctuation, left bracket",
      rrb: "Punctuation, right bracket"
    }.freeze
    
    class << self

      def [](tag)
        DATA[tag]
      end

      def explain(tag)
        DATA[tag] || DATA[tag.to_s.downcase.to_sym] || tag
      end

    end

  end
end