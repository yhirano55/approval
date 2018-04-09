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

  describe "#create_params_for_approval" do
    let(:book) { build :book }
    let(:result) { book.attributes.except("id", "created_at", "updated_at") }

    subject { book.create_params_for_approval }
    it { is_expected.to eq result }
  end

  describe "#update_params_for_approval" do
    let(:book) { create(:book).tap {|book| book.name = "changed name" } }
    let(:result) { { "name" => "changed name" } }

    subject { book.update_params_for_approval }
    it { is_expected.to eq result }
  end
end
