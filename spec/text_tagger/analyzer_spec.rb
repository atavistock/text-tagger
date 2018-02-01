require "spec_helper"

RSpec.describe TextTagger::Analyzer do

  before(:all) do
    text_file = File.join(File.dirname(__FILE__), "../fixtures/files/article1.txt")
    text = File.read(text_file)
    @analyzed = TextTagger::Analyzer.new(text)
  end
  
  it "has words" do
    expect(@analyzed.words).not_to be nil
    puts @analyzed.tokens.join("\n")
  end

end