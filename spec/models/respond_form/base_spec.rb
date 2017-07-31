require "spec_helper"

RSpec.describe Approval::RespondForm::Base, type: :model do
  let(:form) { described_class.new(user: user, reason: reason, request: request) }

  describe "Validation" do
    let(:user) { create :user }
    let(:reason) { "reason" }
    let(:request) do
      build(:request, :pending).tap do |request|
        request.comments << build(:comment, user: request.request_user)
        request.items << build(:item, :create)
        request.save!
      end
    end

    subject { form }

    it { is_expected.to validate_presence_of(:user) }
    it { is_expected.to validate_presence_of(:reason) }
    it { is_expected.to validate_length_of(:reason).is_at_most(Approval.config.comment_maximum) }
    it { is_expected.to validate_presence_of(:request) }
  end

  describe "#save" do
    context "when invalid" do
      let(:user) { create :user }
      let(:reason) { "" }
      let(:request) do
        build(:request, :pending).tap do |request|
          request.comments << build(:comment, user: request.request_user)
          request.items << build(:item, :create)
          request.save!
        end
      end

      it { expect(form.save).to eq false }
    end

    context "when valid" do
      let(:user) { create :user }
      let(:reason) { "reason" }
      let(:request) do
        build(:request, :pending).tap do |request|
          request.comments << build(:comment, user: request.request_user)
          request.items << build(:item, :create)
          request.save!
        end
      end

      it { expect { form.save }.to raise_error(NotImplementedError) }
    end
  end

  describe "#save!" do
    context "when invalid" do
      let(:user) { create :user }
      let(:reason) { "" }
      let(:request) do
        build(:request, :pending).tap do |request|
          request.comments << build(:comment, user: request.request_user)
          request.items << build(:item, :create)
          request.save!
        end
      end

      it { expect { form.save! }.to raise_error(::ActiveRecord::RecordInvalid) }
    end

    context "when valid" do
      let(:user) { create :user }
      let(:reason) { "reason" }
      let(:request) do
        build(:request, :pending).tap do |request|
          request.comments << build(:comment, user: request.request_user)
          request.items << build(:item, :create)
          request.save!
        end
      end

      it { expect { form.save! }.to raise_error(NotImplementedError) }
    end
  end
end
