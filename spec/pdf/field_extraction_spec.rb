RSpec.describe PDF::Extract::Document do
  include ImageMacros

  let(:data_path) { File.join(File.expand_path("../../", __FILE__), "data", "field-examples") }
  let(:pdf_path) { File.join(data_path, pdf_name) }

  context "given an empty PDF" do
    let(:pdf_name) { "empty.pdf" }

    it "can extract no fields" do
      subject = described_class.new(path: pdf_path)

      expect(subject.fields.count).to eq(0)
    end
  end

  context "given a PDF with a barcode" do
    let(:pdf_name) { "barcode.pdf" }

    it "can extract the field" do
      subject = described_class.new(path: pdf_path)

      expect(subject.fields).to include_text_field("Sample Barcode").
        with_value("First Name\tLast Name\rFirst\tLast")
    end
  end

  context "given a PDF with buttons" do
    let(:pdf_name) { "buttons.pdf" }

    it "can extract the fields" do
      subject = described_class.new(path: pdf_path)

      expect(subject.fields).to include_button("Sample Button").with_value(:Off)
      expect(subject.fields).to include_button("Reset Button").with_value(:Off)
    end
  end

  context "given a PDF with check boxes" do
    let(:pdf_name) { "check-boxes.pdf" }

    it "can extract the fields" do
      subject = described_class.new(path: pdf_path)

      # See p686 regarding usage of "Off" and "Yes"
      expect(subject.fields).to include_button("Sample Check Box").with_value(:Yes)
      expect(subject.fields).to include_button("Sample Check Box (required)").with_value(:Off)
      expect(subject.fields).to include_button("Sample Check Box (star)").with_value(:Off)
    end
  end

  context "given a PDF with date fields" do
    let(:pdf_name) { "dates.pdf" }

    it "can extract the fields" do
      subject = described_class.new(path: pdf_path)

      expect(subject.fields).to include_text_field("Sample Date").with_value("jan 1, 2017")
      expect(subject.fields).to include_text_field("Sample Date and Time_af_date").with_value("jan 1, 2017")
    end
  end

  context "given a PDF with dropdowns" do
    let(:pdf_name) { "dropdowns.pdf" }

    it "can extract the fields" do
      subject = described_class.new(path: pdf_path)

      expect(subject.fields).to include_choice_field("Sample Dropdown").with_value("Sample Item 2")
      expect(subject.fields).to include_choice_field("Sample Dropdown (custom text)").with_value("Custom Item")
    end
  end

  context "given a PDF with an image field" do
    let(:pdf_name) { "image.pdf" }

    it "can extract the fields" do
      subject = described_class.new(path: pdf_path)

      expect(subject.fields).to include_button("Sample Image_af_image").with_image(white_pixel_image_base64).with_value(nil)
    end
  end

  context "given a PDF with list boxes" do
    let(:pdf_name) { "list-boxes.pdf" }

    it "can extract the fields" do
      subject = described_class.new(path: pdf_path)

      expect(subject.fields).to include_choice_field("Sample List Box").with_value("Sample Item 1")
      expect(subject.fields).to include_choice_field("Sample List Box (multiple selection)").with_value(["B", "C"])
    end
  end

  context "given a PDF with radio buttons" do
    let(:pdf_name) { "radio-buttons.pdf" }

    it "can extract the fields" do
      subject = described_class.new(path: pdf_path)
      expect(subject.fields.count).to eq(1)

      expect(subject.fields).to include_button("Sample Group").with_value(:"Sample Radio Button 1")
    end
  end

  context "given a PDF with a signature capture" do
    let(:pdf_name) { "signature.pdf" }

    it "can extract the fields" do
      subject = described_class.new(path: pdf_path)

      expect(subject.fields).to include_signature("Sample Signature").with_value({Contents: "", Type: :Sig})
    end
  end

  context "given a PDF with a calculation" do
    let(:pdf_name) { "calculation.pdf" }

    it "can extract the fields" do
      subject = described_class.new(path: pdf_path)
      expect(subject.fields.count).to eq(3)

      expect(subject.fields).to include_text_field("Value 1").with_value("3")
      expect(subject.fields).to include_text_field("Value 2").with_value("7")
      expect(subject.fields).to include_text_field("Total").with_value("10")
    end
  end

  context "given a PDF with text fields" do
    let(:pdf_name) { "text.pdf" }

    it "can extract the fields" do
      subject = described_class.new(path: pdf_path)

      expect(subject.fields).to include_text_field("Sample Text Field").with_value("Hello")
      expect(subject.fields).to include_text_field("Sample Text Field (required)").with_value(nil)
    end
  end

end
