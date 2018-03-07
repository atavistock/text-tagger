require "spec_helper"

RSpec.describe TextTagger::Token do
  it "generates 'readable' value from word and tag" do
    token = TextTagger::Token.new(1, 'thumbprint', :nn)
    expect(token.readable).to eq('thumbprint/NN')
  end

  it "gets a lemma from the word" do
    token = TextTagger::Token.new(1, 'detectives', :nns)
    expect(token.lemma).to eq('detective')
  end

end
