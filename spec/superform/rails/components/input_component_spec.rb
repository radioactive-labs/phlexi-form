RSpec.describe Superform::Rails::Components::InputComponent do
  let(:field) do
    object = double("object", "foo=": nil)
    object = double("object", "foo": value)
    Superform::Field.new(:foo, parent: nil, object:)
  end
  let(:value) do
    "a string"
  end
  let(:attributes) do
    {}
  end
  let(:component) do
    described_class.new(field, attributes: attributes)
  end
  subject { component }

  it { is_expected.to_not have_client_provided_value }
  it "is type: :text by default" do
    expect(subject.type).to be_text
  end

  describe "type inference from value" do
    subject { component.type }
    context "String" do
      let(:value) { "just a string" }
      it { is_expected.to be_text }
    end
    context "Integer" do
      let(:value) { 100 }
      it { is_expected.to be_number }
    end
    context "Float" do
      let(:value) { 100.0 }
      it { is_expected.to be_number }
    end
    context "URL" do
      let(:value) { URI("http://example.com") }
      it { is_expected.to be_url }
    end
    context "Date" do
      let(:value) { Date.today }
      it { is_expected.to be_date }
    end
    context "DateTime" do
      let(:value) { DateTime.now }
      it { is_expected.to be_date }
    end
    context "Time" do
      let(:value) { Time.now }
      it { is_expected.to be_time }
    end
  end

  context "type: :image" do
    let(:attributes) do
      { type: :image }
    end
    it { is_expected.to have_client_provided_value }
  end

  context "type: 'file'" do
    let(:attributes) do
      { type: "file" }
    end
    it { is_expected.to have_client_provided_value }
  end
end
