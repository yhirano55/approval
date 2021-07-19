require "spec_helper"

RSpec.describe Approval::RequestForm::Update do
  describe "#save" do
    let(:user) { create :user }
    let(:reason) { "reason" }
    let(:form) { described_class.new(user: user, reason: reason, records: records) }

    subject { form.save }

    context "when records is single" do
      let(:records) do
        book = create(:book)
        book.name = "changed name"
        book
      end

      it { expect { subject }.not_to raise_error }
      it { expect { subject }.to change { Approval::Item.count }.from(0).to(1) }
    end

    context "when records is multiple" do
      let(:records) do
        books = create_list(:book, 3)
        books.map.with_index {|book, i| book.name = "changed name #{i}" }
        books
      end

      it { expect { subject }.not_to raise_error }
      it { expect { subject }.to change { Approval::Item.count }.from(0).to(3) }
    end
  end
end
