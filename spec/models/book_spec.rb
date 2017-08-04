require "spec_helper"

RSpec.describe Book, type: :model do
  it { is_expected.to have_many(:approval_items).class_name("Approval::Item") }

  describe ".assign_ignore_fields" do
    subject { described_class.assign_ignore_fields(ignore_fields) }

    context "when ignore_fields are duplicated symbolized value" do
      let(:ignore_fields) { %i[id id created_at updated_at] }
      it { is_expected.to match_array %w[id created_at updated_at] }
    end
  end

  describe "#params_for_approval" do
    let(:book) { build :book }
    let(:result) { book.attributes.except("id", "created_at", "updated_at") }

    subject { book.params_for_approval }
    it { is_expected.to eq result }
  end
end
