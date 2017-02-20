describe Ryan do
  subject { described_class.new(input) }

  let(:input) { described_class.root.join('spec/fixtures/report.rb') }

  describe ".root" do
    it "should return the path to gem's root" do
      expect(described_class.root.to_s[%r'/ryan\z']).to eq "/ryan"
    end
  end

  describe "#initialize" do
    context "when reading parsable code from a file, the v1 default" do
      it "should return an instance of Ryan" do
        expect(subject.class).to eq described_class
        expect(subject.name).to eq "Report"
      end
    end

    context "when initialized with text input" do
      let(:input) { File.read(described_class.root.join('spec/fixtures/report.rb')) }

      it "should work as if the code was read from a file - correctly set #const and return Ryan instance" do
        expect(subject.class).to eq described_class
        expect(subject.name).to eq "Report"
      end
    end

    context "when initialized with raw ruby code" do
      let(:input) { "class User; def method; end; end" }

      it "should work as if the code was read from a file - correctly set #const and return Ryan instance" do
        expect(subject.class).to eq described_class
        expect(subject.name).to eq "User"
      end
    end

  end

end
