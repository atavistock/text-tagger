lib = File.expand_path("../lib", __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require "text_tagger/version"

Gem::Specification.new do |spec|
  spec.name          = "text_tagger"
  spec.version       = TextTagger::VERSION
  spec.authors       = ["Aaron Tavistock"]
  spec.summary       = %q{A probability based, corpus-trained English part-of-speech tagger}
  spec.description   = %q{Not a port or conversion, but heavily inspired by the text_tagger gem}
  spec.homepage      = ""

    # Prevent pushing this gem to RubyGems.org. To allow pushes either set the 'allowed_push_host'
  # to allow pushing to a single host or delete this section to allow pushing to any host.
  if spec.respond_to?(:metadata)
    spec.metadata["allowed_push_host"] = "TODO: Set to 'http://mygemserver.com'"
  else
    raise "RubyGems 2.0 or newer is required to protect against public gem pushes."
  end

  spec.files         = `git ls-files -z`.split("\x0").reject do |f|
    f.match(%r{^(test|spec|features)/})
  end


  spec.files         = `git ls-files -z`.split("\x0")
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.7"
  spec.add_development_dependency "rake", "~> 10.0"
  spec.add_development_dependency "rspec", "~> 3.7"

  spec.add_dependency "lemmatizer", "~> 0.1"
  spec.add_dependency "activerecord", ">= 5.2", "< 7.0"

end
