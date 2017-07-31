require "spec_helper"

RSpec.describe Book, type: :model do
  it { is_expected.to have_many(:approval_items).class_name("Approval::Item") }

  describe ".append_ignore_fields" do
    subject { described_class.append_ignore_fields(ignore_fields) }

    context "when ignore_fields are blank" do
      let(:ignore_fields) { [] }
      it { is_expected.to match_array Approval::Mixins::Resource::DEFAULT_IGNORE_FIELDS }
    end

    context "when ignore_fields are present" do
      let(:ignore_fields) { ["published_at"] }
      it { is_expected.to match_array Approval::Mixins::Resource::DEFAULT_IGNORE_FIELDS.dup.concat(["published_at"]) }
    end
  end

  describe "#params_for_approval" do
    let(:book) { build :book }
    let(:result) { book.attributes.except("id", "created_at", "updated_at") }

    subject { book.params_for_approval }
    it { is_expected.to eq result }
  end
end
