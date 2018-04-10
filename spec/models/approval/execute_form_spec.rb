require "spec_helper"

RSpec.describe Approval::ExecuteForm, type: :model do
  let(:form) { described_class.new(user: user, reason: reason, request: request) }

  describe "Validation" do
    let(:user) { create :user }
    let(:reason) { "reason" }
    let(:request) do
      build(:request, :pending, request_user: user).tap do |request|
        request.comments << build(:comment, user: request.request_user)
        request.items << build(:item, :create)
        request.save!
      end
    end

    subject { form }

    it { is_expected.to validate_presence_of(:user) }
    it { is_expected.to validate_presence_of(:request) }
    it { is_expected.to allow_value(nil).for(:reason) }
    it { is_expected.to validate_length_of(:reason).is_at_most(Approval.config.comment_maximum) }
  end

  describe "#save" do
    context "when invalid" do
      let(:user) { create :user }
      let(:reason) { "" }
      let(:request) do
        build(:request, :pending, request_user: user).tap do |request|
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
        build(:request, :approved, request_user: user).tap do |request|
          request.comments << build(:comment, user: request.request_user)
          request.items << build(:item, :create)
          request.save!
        end
      end

      subject { form.save }

      it { is_expected.to eq true }
      it { expect { subject }.to change { Book.count }.by(1) }
      it { expect { subject }.to change { ::Approval::Comment.count }.by(2) }
      it { expect { subject }.to change { request.state }.from("approved").to("executed") }
    end
  end

  describe "#save!" do
    context "when invalid" do
      let(:user) { create :user }
      let(:reason) { "" }
      let(:request) do
        build(:request, :pending, request_user: user).tap do |request|
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
        build(:request, :approved, request_user: user).tap do |request|
          request.comments << build(:comment, user: request.request_user)
          request.items << build(:item, :create)
          request.save!
        end
      end

      it { expect { form.save }.to change { Book.count }.by(1) }
      it { expect { form.save }.to change { ::Approval::Comment.count }.by(2) }
      it { expect { form.save }.to change { request.state }.from("approved").to("executed") }
    end
  end
end
