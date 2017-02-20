require "spec_helper"
# rspec spec/lib/ryan.rb
describe Ryan do

  describe ".root" do
    it "should return the path to gem's root" do
      expect(described_class.root.to_s[%r'/ryan\z']).to eq "/ryan"
    end
  end

  describe "#initialize" do
    let(:path) { described_class.root + "spec/fixtures/report.rb" }

    context "when reading parsable code from a file, the v1 default" do
      subject { described_class.new(path) }

      it "should return an instance of Ryan" do
        expect(subject.class).to eq described_class
        expect(subject.name).to eq "Report"
      end
    end

    context "when initialized with text argument and mode=:text" do
      let(:text) { File.read(path) }
      subject { described_class.new(text, :text) }

      it "should work as if the code was read from a file - correctly set #const and return Ryan instance" do
        expect(subject.class).to eq described_class
        expect(subject.name).to eq "Report"
      end
    end

    context "when initialized with handwritten ruby code" do
      let(:text) { "class User; def method; end; end" }
      subject { described_class.new(text, :text) }

      it "should work as if the code was read from a file - correctly set #const and return Ryan instance" do
        expect(subject.class).to eq described_class
        expect(subject.name).to eq "User"
      end
    end

  end

end
