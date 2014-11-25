require 'spec_helper'

describe Fukuzatsu::Parser do

  let(:parser) { Fukuzatsu::Parser.new(
      "./fixtures/",
      "formatter proxy",
      14
    )
  }

  describe "#initialize" do
    it "initializes its path to files" do
      expect(parser.path_to_files).to eq "./fixtures/"
    end
  end

  describe "check_complexity" do
    it "returns if no threshold is set" do
      allow(parser).to receive(:threshold) { 0 }
      expect(parser.send(:check_complexity)).to be_nil
    end
    it "returns if threshold is not exceeded" do
      allow(parser).to receive(:threshold) { 5 }
      allow(parser).to receive(:average_complexities) { [1,2,3,4,5] }
      expect(parser.send(:check_complexity)).to be_nil
    end
    it "returns an exit code if threshold exceeded" do
      allow(parser).to receive(:threshold) { 5 }
      allow(parser).to receive(:average_complexities) { [1,2,3,4,5,6] }
      begin
        parser.send(:check_complexity)
      rescue SystemExit => e
        expect(e.message).to eq("exit")
      end
    end
  end

end
