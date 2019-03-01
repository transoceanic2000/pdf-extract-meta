RSpec.describe PDF::Extract::ReferenceResolver do

  let(:document) { OpenStruct.new(objects: objects) }

  subject { described_class.new(document: document) }

  context "given a map of document references" do
    let(:objects) {
      {
        a: 1,
        b: 2,
        x: [:a],
        y: [:a, :x, :b],
      }
    }

    it "can lookup a single reference" do
      expect(subject.lookup(:a)).to eq(1)
    end

    it "can lookup an nested reference" do
      expect(subject.lookup(:x)).to eq([1])
    end

    it "can lookup a deeply nested reference" do
      expect(subject.lookup(:y)).to eq([1, 1, 2])
    end

    it "can lookup an array of references" do
      expect(subject.lookup([:a, :b])).to eq([1, 2])
    end

    it "can lookup an array of references" do
      expect(subject.lookup([:x, :x])).to eq([1, 1])
    end
  end

  context "given a map with infinite recursion" do
    let(:objects) {
      {
        a: [:b],
        b: [:a],
      }
    }

    it "can lookup a single reference" do
      expect { subject.lookup(:a) }.to raise_error(PDF::Extract::Error, "map contains infinite recursion")
    end
  end

end
