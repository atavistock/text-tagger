module TextTagger
  class Splitter

    attr_reader :text

    def initialize(text)
      @text = text.clone
    end

    def parse
      standardize_and_isolate_quotes!
      preserve_proper_nouns!
      isolate_punctuation!
      isolate_contractions!
      components = @text.split(/\s+/o)
      components.map! { |element| reverse_proper_noun(element) }
      components
    end

    private

    def standardize_and_isolate_quotes!
      @text.gsub!(/`(?!`)(?=.*\w)/o, "` ")                     # Shift left quotes off text
      @text.gsub!(/"(?=.*\w)/o, " `` ")                        # Convert left quotes to ``
      @text.gsub!(/(\W|^)'(?=.*\w)/o){$1 ? "#{$1} ` " : " ` "} # Convert left quotes to `
      @text.gsub!(/"/, " '' ")                                 # Convert (remaining) quotes to ''
      @text.gsub!(/(\w)'(?!')(?=\W|$)/o){"#{$1} ' "}           # Separate right single quotes
    end

    def isolate_punctuation!
      @text.gsub!(/--+/o, " - ")                  # squeeze and isolate hyphens
      @text.gsub!(/,(?!\d)/o, " , ")              # isolate commas except inside numbers
      @text.gsub!(/:/o, " :")                     # isolate colons
      @text.gsub!(/(\.\.\.+)/o){" #{$1} "}        # isolate ellipses
      @text.gsub!(/([\(\[\{\}\]\)])/o){" #{$1} "} # isolate brackets
      @text.gsub!(/([\.\!\?#\$%;~|])/o){" #{$1} "}  # isolate other standard punctuation (not period because it could be used for abbreviations)
    end

    def isolate_contractions!
      @text.gsub!(/([A-Za-z])'([dms])\b/o){"#{$1} '#{$2}"}  # isolate 'd 'm 's
      @text.gsub!(/n't\b/o, " n't")                         # isolate n't
      @text.gsub!(/'(ve|ll|re)\b/o){" '#{$1}"}              # isolate 've, 'll, 're
    end

    def preserve_proper_nouns!
      @text.gsub!(/((?:\b[A-Z][A-Za-z0-9]*\b)(?:\s+\b[A-Z][A-Za-z0-9]*\b)+)/) { format_proper_noun($1) }
    end

    def format_proper_noun(str)
      "__#{str.gsub(/\s/, '_')}__"
    end

    def reverse_proper_noun(str)
      if /\A__\w+__\Z/.match?(str)
        str.gsub('_', ' ').strip
      else
        str
      end
    end

  end
end
