RSpec.describe PDF::Extract::Document do

  let(:data_path) { File.join(File.expand_path("../../", __FILE__), "data", "annotation-examples") }
  let(:pdf_path) { File.join(data_path, pdf_name) }

  context "given an empty PDF" do
    let(:pdf_name) { "hello-world.pdf" }

    it "can extract no annotations" do
      subject = described_class.new(path: pdf_path)
      expect(subject.annotations.count).to eq(0)
    end
  end

  context "given a PDF with highlighting" do
    let(:pdf_name) { "highlight.pdf" }

    it "can extract the annotation" do
      subject = described_class.new(path: pdf_path)
      expect(subject.annotations).to include_highlight
    end
  end

  context "given a PDF with a line" do
    let(:pdf_name) { "line.pdf" }

    it "can extract the annotation" do
      subject = described_class.new(path: pdf_path)
      expect(subject.annotations).to include_line
    end
  end

  context "given a PDF with a loupe" do
    let(:pdf_name) { "loupe.pdf" }

    it "can extract the annotation" do
      subject = described_class.new(path: pdf_path)
      expect(subject.annotations).to include_stamp
    end
  end

  context "given a PDF with a mask" do
    let(:pdf_name) { "mask.pdf" }

    it "can extract the annotation" do
      subject = described_class.new(path: pdf_path)
      expect(subject.annotations).to include_stamp
    end
  end

  context "given a PDF with notes" do
    let(:pdf_name) { "note.pdf" }

    it "can extract the annotations" do
      subject = described_class.new(path: pdf_path)
      expect(subject.annotations).to include_text.with_contents("Hello")
      expect(subject.annotations).to include_popup.with_contents("Hello")
    end
  end

  context "given a PDF with a oval" do
    let(:pdf_name) { "oval.pdf" }

    it "can extract the annotation" do
      subject = described_class.new(path: pdf_path)
      expect(subject.annotations).to include_circle
    end
  end

  context "given a PDF with a polygon" do
    let(:pdf_name) { "polygon.pdf" }

    it "can extract the annotation" do
      subject = described_class.new(path: pdf_path)
      expect(subject.annotations).to include_stamp
    end
  end

  context "given a PDF with a rectangle" do
    let(:pdf_name) { "rectangle.pdf" }

    it "can extract the annotation" do
      subject = described_class.new(path: pdf_path)
      expect(subject.annotations).to include_square
    end
  end

  context "given a PDF with a speech-bubble" do
    let(:pdf_name) { "speech-bubble.pdf" }

    it "can extract the annotation" do
      subject = described_class.new(path: pdf_path)
      expect(subject.annotations).to include_stamp.with_contents("Hello!")
    end
  end

  context "given a PDF with a stamp" do
    let(:pdf_name) { "stamp.pdf" }

    it "can extract the annotation" do
      subject = described_class.new(path: pdf_path)
      expect(subject.annotations).to include_stamp("d75815b6-c324-ca40-97f4-182f25bf69ac")
      expect(subject.annotations).to include_popup
    end
  end

  context "given a PDF with a star" do
    let(:pdf_name) { "star.pdf" }

    it "can extract the annotation" do
      subject = described_class.new(path: pdf_path)
      expect(subject.annotations).to include_stamp
    end
  end

  context "given a PDF with a sticky note" do
    let(:pdf_name) { "sticky-note.pdf" }

    it "can extract the annotation" do
      subject = described_class.new(path: pdf_path)
      expect(subject.annotations).to include_text("ec6073af-22ae-8048-baab-9e144b18ae7c").with_contents("Hello")
      expect(subject.annotations).to include_text("0b2eacfe-6c0d-cb43-9434-60e08b49d086").with_contents("World")
      expect(subject.annotations).to include_text("55bd79fb-6523-a640-a5b2-5d118aefb45c")
      expect(subject.annotations).to include_popup(multiple: true)
    end
  end

  context "given a PDF with a strikethrough" do
    let(:pdf_name) { "strikethrough.pdf" }

    it "can extract the annotation" do
      subject = described_class.new(path: pdf_path)
      expect(subject.annotations).to include_strike_out
    end
  end

  context "given a PDF with free text" do
    let(:pdf_name) { "text.pdf" }

    it "can extract the annotation" do
      subject = described_class.new(path: pdf_path)
      expect(subject.annotations).to include_free_text.with_contents("Annotated Text")
    end
  end

  context "given a PDF with an underline" do
    let(:pdf_name) { "underline.pdf" }

    it "can extract the annotation" do
      subject = described_class.new(path: pdf_path)
      expect(subject.annotations).to include_underline
    end
  end

end
