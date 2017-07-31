require "spec_helper"

RSpec.describe Approval::RequestForm::Base, type: :model do
  let(:form) { described_class.new(user: user, reason: reason, records: records) }

  describe "Validation" do
    let(:user) { create :user }
    let(:reason) { "reason" }
    let(:records) { build :book }

    subject { form }

    it { is_expected.to validate_presence_of(:user) }
    it { is_expected.to validate_presence_of(:reason) }
    it { is_expected.to validate_length_of(:reason).is_at_most(Approval.config.comment_maximum) }
    it { is_expected.to validate_presence_of(:records) }
  end

  describe "#save" do
    context "when invalid" do
      let(:user) { nil }
      let(:reason) { nil }
      let(:records) { nil }

      it { expect(form.save).to eq false }
    end

    context "when valid" do
      let(:user) { create :user }
      let(:reason) { "reason" }
      let(:records) { build :book }

      it { expect { form.save }.to raise_error(NotImplementedError) }
    end
  end

  describe "#save!" do
    context "when invalid" do
      let(:user) { nil }
      let(:reason) { nil }
      let(:records) { nil }

      it { expect { form.save! }.to raise_error(::ActiveRecord::RecordInvalid) }
    end

    context "when valid" do
      let(:user) { create :user }
      let(:reason) { "reason" }
      let(:records) { build :book }

      it { expect { form.save! }.to raise_error(NotImplementedError) }
    end
  end
end
