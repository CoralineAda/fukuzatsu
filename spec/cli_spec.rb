require 'spec_helper'

describe Fukuzatsu::CLI do

  let(:cli) { Fukuzatsu::CLI.new }

  describe "#check" do
    it "invokes Fukuzatsu" do
      expect(Fukuzatsu).to receive(:new) { Struct.new(:report).new("OK") }
      cli.check("./fixtures")
    end
  end

end

