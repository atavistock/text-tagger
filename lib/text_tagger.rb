require 'yaml'

require_relative 'text_tagger/analyzer'
require_relative 'text_tagger/word'
require_relative 'text_tagger/splitter'
require_relative 'text_tagger/tag_definition'
require_relative 'text_tagger/token'
require_relative 'text_tagger/unknown'
require_relative 'text_tagger/version'
require_relative 'text_tagger/word_context'

module TextTagger

  class << self
    attr_accessor :config

    def configure
      @config ||= Config.new
      yield(@config)

      Lexicon.preload
      WordContext.preload
      TagDefinition.preload
    end

    def analyze(word)
      TextTagger::Analyze.new(word)
    end
  end

end
